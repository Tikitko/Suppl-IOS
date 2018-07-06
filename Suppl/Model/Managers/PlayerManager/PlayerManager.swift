import Foundation
import AVFoundation
import AVKit
import MediaPlayer

final class PlayerManager: NSObject {
    
    static public let s = PlayerManager()
    private override init() {
        super.init()
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try? AVAudioSession.sharedInstance().setActive(true)
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    private var player: AVPlayer?
    private var needPlayingStatus = false
    private var observerPlayStatusWorking = false
    private var observerPlayerRateWorking = false
    private var timeObserver: Any?
    
    private var playlist: Playlist?
    private(set) var currentTrack: CurrentTrack?
    
    private var cachedTracksInfo: [AudioData]?
    
    private let mapTableDelegates = NSMapTable<NSString, AnyObject>(keyOptions: NSPointerFunctions.Options.strongMemory, valueOptions: NSPointerFunctions.Options.weakMemory)
    
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
        player?.currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.new, .old], context: nil)
    }
    
    private func removePlayStatusObserver() {
        if player == nil { return }
        if !observerPlayStatusWorking { return }
        player?.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        observerPlayStatusWorking = false
    }
    
    private func addPlayerRateObserver() {
        if player == nil { return }
        if observerPlayerRateWorking { return }
        observerPlayerRateWorking = true
        player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate), options: [.new, .old], context: nil)
    }
    
    private func removePlayerRateObserver() {
        if player == nil { return }
        if !observerPlayerRateWorking { return }
        player?.removeObserver(self, forKeyPath: #keyPath(AVPlayer.rate))
        observerPlayerRateWorking = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath, let statusNumber = change?[.newKey] as? NSNumber else { return }
        switch keyPath {
        case #keyPath(AVPlayerItem.status): observePlayerItemStatus(statusNumber)
        case #keyPath(AVPlayer.rate): observePlayerRate(statusNumber)
        default: break
        }
    }
    
    private func observePlayerItemStatus(_ statusNumber: NSNumber) {
        removePlayStatusObserver()
        let status: AVPlayerItemStatus = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
        switch status {
        case .readyToPlay:
            guard let player = player, let item = player.currentItem else { return }
            timeObserver = player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { [weak self] (time) -> Void in
                guard let `self` = self, item.status == .readyToPlay else { return }
                self.sayToListeners() { delegate in
                    delegate.itemTimeChanged(item, time.seconds)
                }
                self.nowPlayingCenter.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = time.seconds
            }
            sayToListeners() { delegate in
                delegate.itemReadyToPlay(item, currentTrack?.duration)
            }
            remoteCommands(isEnabled: true)
            play()
        case .failed: break
        case .unknown: break
        }
    }
    
    private func observePlayerRate(_ statusNumber: NSNumber) {
        let rate: Int = statusNumber.intValue
        if rate == 1 {
            sayToListeners() { delegate in
                delegate.playerPlay()
            }
        } else if rate == 0 {
            sayToListeners() { delegate in
                delegate.playerStop()
            }
            guard let currentItem = player?.currentItem else { return }
            if SettingsManager.s.autoNextTrack!, Int(currentItem.duration.seconds - round(currentItem.currentTime().seconds)) < 1, let _ = playlist {
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
        //commandCenter().nextTrackCommand.isEnabled = isEnabled
        //commandCenter().previousTrackCommand.isEnabled = isEnabled
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
    
    private func loadTrackByID(_ trackID: String) {
        guard let keys = AuthManager.s.getAuthKeys() else { return }
        removeTrack()
        currentTrack = nil
        var loadedFromCache = false
        for track in cachedTracksInfo ?? [] {
            if track.id != trackID { continue }
            setTrackInfo(track)
            loadedFromCache = true
            break
        }
        if let item = PlayerItemsManager.s.getItem(trackID) {
            setTrack(item: item)
            return
        }
        APIManager.s.audio.get(keys: keys, ids: trackID) { [weak self] error, data in
            guard let list = data?.list, list.count > 0, let trackURL = URL(string: list[0].track ?? ""), self?.currentTrack?.id == list[0].id else { return }
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
        currentTrack = CurrentTrack(id: track.id, title: track.title, performer: track.performer, duration: track.duration, image: nil)
        sayToListeners() { delegate in
            delegate.trackInfoChanged(currentTrack!, nil)
        }
        let nowPlayingInfo = [
            MPMediaItemPropertyTitle: track.title,
            MPMediaItemPropertyArtist: track.performer,
            MPMediaItemPropertyPlaybackDuration: track.duration,
            MPNowPlayingInfoPropertyPlaybackRate: NSNumber(value: 1.0 as Float)
        ] as [String: Any]
        nowPlayingCenter.nowPlayingInfo = nowPlayingInfo as [String: AnyObject]?
        guard SettingsManager.s.loadImages! else { return }
        RemoteDataManager.s.getCachedImageAsData(link: track.images.last ?? "") { [weak self] imageData in
            guard let `self` = self, track.id == self.currentTrack?.id, let image = UIImage(data: imageData as Data) else { return }
            self.currentTrack?.image = image
            self.sayToListeners() { delegate in
                delegate.trackInfoChanged(self.currentTrack!, imageData as Data)
            }
            self.nowPlayingCenter.nowPlayingInfo?[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
        }
    }
    
    public func clearPlayer() {
        sayToListeners() { delegate in
            delegate.playlistRemoved()
        }
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
        nowPlayingCenter.nowPlayingInfo = nil
        removeRemoteCommands()
    }
    
    public func setPlaylist(tracksIDs: [String], current: Int = 0, cachedTracksInfo: [AudioData]? = nil) {
        guard let playlistNew = Playlist(IDs: tracksIDs, current: current), self.playlist?.curr != tracksIDs[current] else { return }
        playlist = playlistNew
        self.cachedTracksInfo = cachedTracksInfo
        loadTrackByID(playlist!.curr)
        sayToListeners() { delegate in
            guard let playlist = playlist else { return }
            delegate.playlistAdded(playlist)
        }
        addRemoteCommands()
        remoteCommands(isEnabled: false)
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
        if !currentItem.duration.seconds.isNaN, Int(currentItem.duration.seconds - currentItem.currentTime().seconds) == 0 {
            setPlayerCurrentTime(0)
        }
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
        loadTrackByID(playlist!.randomSortAndFirst())
    }
    
    public func playOrPause() {
        player?.rate == 0 ? play() : pause()
    }
    
    public func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool = false) {
        guard let player = player, let currentItem = player.currentItem else { return }
        player.seek(to: CMTimeMake(Int64(withCurrentTime ? currentItem.currentTime().seconds + sec : sec), 1))
    }

}
