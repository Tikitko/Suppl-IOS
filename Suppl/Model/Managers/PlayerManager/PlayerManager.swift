import Foundation
import AVFoundation
import AVKit
import MediaPlayer

final class PlayerManager: NSObject {
    
    static public let shared = PlayerManager()
    private override init() {
        super.init()
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    private var player: AVPlayer?
    private var needPlayingStatus = false
    private var observerPlayStatusWorking = false
    private var observerPlayerRateWorking = false
    private var timeObserver: Any?
    
    private(set) var playlist: Playlist? {
        didSet { sayToListeners({ $0.playlistChanged(playlist) }) }
    }
    private(set) var currentTrack: CurrentTrack?
    
    private var cachedTracksInfo: [AudioData]?
    
    private let mapTableDelegates = NSMapTable<NSString, AnyObject>(keyOptions: .strongMemory, valueOptions: .weakMemory)
    
    public func setListener(name: String, delegate: PlayerListenerDelegate) {
        mapTableDelegates.setObject(delegate, forKey: name as NSString)
    }
    
    private func getListener(name: String) -> PlayerListenerDelegate? {
        return mapTableDelegates.object(forKey: name as NSString) as? PlayerListenerDelegate
    }
    
    private func sayToListeners(_ callback: (PlayerListenerDelegate) -> Void) {
        for obj in mapTableDelegates.objectEnumerator() ?? NSEnumerator() {
            guard let delegate = obj as? PlayerListenerDelegate else { continue }
            callback(delegate)
        }
    }
    
    private func addPlayStatusObserver() {
        if player == nil { return }
        if observerPlayStatusWorking { return }
        observerPlayStatusWorking = true
        player?.currentItem?.addObserver(
            self,
            forKeyPath: #keyPath(AVPlayerItem.status),
            options: [.new, .old],
            context: nil
        )
    }
    
    private func removePlayStatusObserver() {
        if player == nil { return }
        if !observerPlayStatusWorking { return }
        player?.currentItem?.removeObserver(
            self,
            forKeyPath: #keyPath(AVPlayerItem.status)
        )
        observerPlayStatusWorking = false
    }
    
    private func addPlayerRateObserver() {
        if player == nil { return }
        if observerPlayerRateWorking { return }
        observerPlayerRateWorking = true
        player?.addObserver(
            self,
            forKeyPath: #keyPath(AVPlayer.rate),
            options: [.new, .old],
            context: nil
        )
    }
    
    private func removePlayerRateObserver() {
        if player == nil { return }
        if !observerPlayerRateWorking { return }
        player?.removeObserver(
            self,
            forKeyPath: #keyPath(AVPlayer.rate)
        )
        observerPlayerRateWorking = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath,
              let statusNumber = change?[.newKey] as? NSNumber
            else { return }
        switch keyPath {
        case #keyPath(AVPlayerItem.status): observePlayerItemStatus(statusNumber)
        case #keyPath(AVPlayer.rate): observePlayerRate(statusNumber)
        default: break
        }
    }
    
    private func observePlayerItemStatus(_ statusNumber: NSNumber) {
        removePlayStatusObserver()
        let status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
        switch status {
        case .readyToPlay:
            guard let player = player, let item = player.currentItem else { return }
            sayToListeners({ $0.itemReadyToPlay(item, currentTrack?.duration) })
            timeObserver = player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: .main) { [weak self, weak player, weak item] time in
                guard let self = self, let player = player, let item = item, item.status == .readyToPlay else { return }
                self.sayToListeners({ $0.itemTimeChanged(item, time.seconds) })
                switch player.timeControlStatus {
                case .waitingToPlayAtSpecifiedRate, .paused:
                    self.currentTrack?.elapsedPlaybackTime = time.seconds
                    self.currentTrack?.playbackRate = 0
                    self.nowPlayingCenter.nowPlayingInfo = self.currentTrack?.nowPlayingInfo
                case .playing:
                    self.currentTrack?.elapsedPlaybackTime = time.seconds
                    self.currentTrack?.playbackRate = 1
                    self.nowPlayingCenter.nowPlayingInfo = self.currentTrack?.nowPlayingInfo
                @unknown default: break
                }
            }
            remoteCommands(isEnabled: true)
            play()
        case .failed, .unknown: break
        @unknown default: break
        }
    }
    
    private func observePlayerRate(_ statusNumber: NSNumber) {
        let rate: Int = statusNumber.intValue
        if rate == 1 {
            sayToListeners({ $0.playerPlay() })
        } else if rate == 0 {
            sayToListeners({ $0.playerStop() })
            guard let currentItem = player?.currentItem else { return }
            if SettingsManager.shared.autoNextTrack.value,
               Int(currentItem.duration.seconds - round(currentItem.currentTime().seconds)) < 1,
               let _ = playlist
            {
                loadTrackByID(playlist!.next())
            } else if needPlayingStatus {
                player?.play()
            }
        }
    }
    
    private func addRemoteCommands() {
        commandCenter.playCommand.addTarget(self, action: #selector(play))
        commandCenter.pauseCommand.addTarget(self, action: #selector(pause))
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(nextTrack))
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(prevTrack))
    }
    
    private func removeRemoteCommands() {
        commandCenter.playCommand.removeTarget(self)
        commandCenter.pauseCommand.removeTarget(self)
        commandCenter.nextTrackCommand.removeTarget(self)
        commandCenter.previousTrackCommand.removeTarget(self)
    }
    
    private func remoteCommands(isEnabled: Bool) {
        commandCenter.playCommand.isEnabled = isEnabled
        commandCenter.pauseCommand.isEnabled = isEnabled
    }
    
    private var nowPlayingCenter: MPNowPlayingInfoCenter {
        get { return MPNowPlayingInfoCenter.default() }
    }
    
    private var commandCenter: MPRemoteCommandCenter {
        get { return MPRemoteCommandCenter.shared() }
    }
    
    public var playerRate: Float? {
        get { return player?.rate }
    }
    
    public var currentItemTime: Double? {
        get { return player?.currentItem?.currentTime().seconds }
    }
    
    public var itemDuration: Double? {
        get { return player?.currentItem?.duration.seconds }
    }
    
    public func getPlaylistAsAudioData() -> [AudioData]? {
        guard let playlist = playlist,
              let cachedTracksInfo = cachedTracksInfo
            else { return nil }
        var tracklist: [AudioData] = []
        for ID in playlist.IDs {
            guard let track = cachedTracksInfo.first(where: { $0.id == ID }) else { return nil }
            tracklist.append(track)
        }
        return tracklist
    }
    
    private func loadTrackByID(_ trackID: String) {
        guard let keys = AuthManager.shared.getAuthKeys() else { return }
        removeTrack()
        currentTrack = nil
        var loadedFromCache = false
        for track in cachedTracksInfo ?? [] {
            if track.id != trackID { continue }
            setTrackInfo(track)
            loadedFromCache = true
            break
        }
        if let item = PlayerItemsManager.shared.getItem(trackID) {
            setTrack(item: item)
            return
        }
        APIManager.shared.audio.get(keys: keys, ids: [trackID]) { [weak self] error, data in
            guard let list = data?.list,
                  list.count > 0,
                  let trackURL = URL(string: list[0].track ?? String()),
                  self?.currentTrack?.id == list[0].id
                else { return }
            if !loadedFromCache {
                self?.setTrackInfo(list[0])
            }
            self?.setTrack(url: trackURL)
        }
    }
    
    private func removeTrack() {
        remoteCommands(isEnabled: false)
        removePlayStatusObserver()
        removePlayerRateObserver()
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
        }
        timeObserver = nil
        player = nil
    }
    
    private func setTrack(url trackURL: URL) {
        setTrack(item: AVPlayerItem(url: trackURL))
    }
    
    private func setTrack(item: AVPlayerItem) {
        player = AVPlayer(playerItem: item)
        player?.automaticallyWaitsToMinimizeStalling = false
        addPlayStatusObserver()
        addPlayerRateObserver()
    }
    
    private func setTrackInfo(_ track: AudioData) {
        currentTrack = CurrentTrack(
            id: track.id,
            title: track.title,
            performer: track.performer,
            duration: track.duration
        )
        sayToListeners({ $0.trackInfoChanged(currentTrack!, nil) })
        nowPlayingCenter.nowPlayingInfo = currentTrack?.nowPlayingInfo
        guard SettingsManager.shared.loadImages.value else { return }
        DataManager.shared.getCachedImageAsData(link: track.images.last ?? String()) { [weak self] imageData in
            guard let self = self,
                  track.id == self.currentTrack?.id,
                  let image = UIImage(data: imageData as Data)
                else { return }
            self.currentTrack?.image = image
            self.sayToListeners({ $0.trackInfoChanged(self.currentTrack!, imageData as Data) })
            self.nowPlayingCenter.nowPlayingInfo = self.currentTrack?.nowPlayingInfo
        }
    }
    
    public func clearPlayer() {
        removePlayStatusObserver()
        removePlayerRateObserver()
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
        }
        timeObserver = nil
        player = nil
        currentTrack = nil
        playlist = nil
        cachedTracksInfo = nil
        sayToListeners({ $0.playlistRemoved() })
        nowPlayingCenter.nowPlayingInfo = nil
        removeRemoteCommands()
    }
    
    public func setPlaylist(tracksIDs: [String], current: Int = 0, cachedTracksInfo: [AudioData]? = nil) {
        guard let playlistNew = Playlist(IDs: tracksIDs, current: current),
              self.playlist?.curr != tracksIDs[current]
            else { return }
        playlist = playlistNew
        self.cachedTracksInfo = cachedTracksInfo
        sayToListeners() {
            guard let playlist = playlist else { return }
            $0.playlistAdded(playlist)
        }
        addRemoteCommands()
        remoteCommands(isEnabled: false)
        loadTrackByID(playlist!.curr)
    }
    
    @objc public func nextTrack() {
        if playlist == nil { return }
        loadTrackByID(playlist!.next())
    }
    
    @objc public func prevTrack() {
        if playlist == nil { return }
        loadTrackByID(playlist!.prev())
    }
    
    @objc public func play() {
        guard let player = player, let currentItem = player.currentItem else { return }
        if !currentItem.duration.seconds.isNaN,
            Int(currentItem.duration.seconds - currentItem.currentTime().seconds) == 0
        { setPlayerCurrentTime(0) }
        needPlayingStatus = true
        player.play()
    }
    
    @objc public func pause() {
        guard let player = player, let _ = player.currentItem else { return }
        needPlayingStatus = false
        player.pause()
    }
    
    public func mixAndFirst() {
        if playlist == nil { return }
        var newPlaylist = playlist!
        let _ = newPlaylist.randomSortAndFirst()
        setPlaylist(
            tracksIDs: newPlaylist.IDs,
            cachedTracksInfo: cachedTracksInfo
        )
    }
    
    public func insert(_ id: String, at: Int? = nil, cachedTrackInfo: AudioData? = nil) {
        if playlist == nil { return }
        guard let cachedTrackInfo = cachedTrackInfo else { return }
        let atFinal = at ?? playlist!.IDs.count
        guard let newCurrent = playlist!.insert(id, at: atFinal) else { return }
        if !(cachedTracksInfo?.contains(cachedTrackInfo) ?? true) {
            cachedTracksInfo?.append(cachedTrackInfo)
        }
        sayToListeners() {
            guard let playlist = playlist else { return }
            $0.playlistTrackInserted(cachedTrackInfo, atFinal, playlist)
        }
        if newCurrent != currentTrack?.id {
            loadTrackByID(newCurrent)
        }
    }
    
    public func remove(at: Int) {
        if playlist == nil { return }
        guard let trackId = cachedTracksInfo?.firstIndex(where: { $0.id == playlist!.IDs[at] }) else { return }
        guard let newCurrent = playlist!.remove(at: at) else { return }
        let removedTrack = cachedTracksInfo!.remove(at: trackId)
        sayToListeners() {
            guard let playlist = playlist else { return }
            $0.playlistTrackRemoved(removedTrack, at, playlist)
        }
        if newCurrent != currentTrack?.id {
            loadTrackByID(newCurrent)
        }
    }
    
    public func playOrPause() {
        player?.rate == 0 ? play() : pause()
    }
    
    public func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool = false) {
        guard let player = player, let currentItem = player.currentItem else { return }
        let setTime = Int64(withCurrentTime ? currentItem.currentTime().seconds + sec : sec)
        player.seek(to: CMTimeMake(value: setTime, timescale: 1))
    }

}
