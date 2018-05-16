import Foundation
import AVFoundation
import AVKit
import MediaPlayer

final class PlayerManager: NSObject {
    
    static public let s = PlayerManager()
    private override init() {
        super.init()
    }
    
    private var player: AVPlayer?
    private var needPlayingStatus = false
    private var observerPlayStatusWorking = false
    private var observerPlayerRateWorking = false
    
    private var playlist: Playlist?
    private(set) var currentTrack: CurrentTrack?
    
    public weak var playerListenerOne: PlayerListenerDelegate?
    public weak var playerListenerTwo: PlayerListenerDelegate?
    
    private func addPlayStatusObserver() {
        if observerPlayStatusWorking { return }
        observerPlayStatusWorking = true
        player?.currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.new, .old], context: nil)
    }
    
    private func removePlayStatusObserver() {
        if !observerPlayStatusWorking { return }
        player?.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        observerPlayStatusWorking = false
    }
    
    private func addPlayerRateObserver() {
        if observerPlayerRateWorking { return }
        observerPlayerRateWorking = true
        player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate), options: [.new, .old], context: nil)
    }
    
    private func removePlayerRateObserver() {
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
    
    private func observePlayerItemStatus(_ statusNumber: NSNumber?) {
        removePlayStatusObserver()
        let status: AVPlayerItemStatus = AVPlayerItemStatus(rawValue: statusNumber?.intValue ?? AVPlayerItemStatus.unknown.rawValue)!
        switch status {
        case .readyToPlay:
            player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { [weak self] (CMTime) -> Void in
                guard let `self` = self, let player = self.player, player.currentItem?.status == .readyToPlay else { return }
                self.playerListenerOne?.curentTrackTime(sec: player.currentTime().seconds)
                self.playerListenerTwo?.curentTrackTime(sec: player.currentTime().seconds)
            }
            playerListenerOne?.openControl()
            playerListenerTwo?.openControl()
            remoteCommands(isEnabled: true)
            play()
        case .failed: break
        case .unknown: break
        }
    }
    
    private func observePlayerRate(_ statusNumber: NSNumber?) {
        let rate: Float = statusNumber?.floatValue ?? -1.0
        if rate == 1.0 {
            playerListenerOne?.playerPlay()
            playerListenerTwo?.playerPlay()
        } else if rate == 0.0 {
            playerListenerOne?.playerStop()
            playerListenerTwo?.playerStop()
            guard let currentItem = player?.currentItem else { return }
            if SettingsManager.s.autoNextTrack!, Int(currentItem.duration.seconds - currentItem.currentTime().seconds) == 0, let _ = playlist {
                loadTrackByID(playlist!.next())
            } else if needPlayingStatus {
                player?.play()
            }
        }
    }
    
    private func addRemoteCommands() {
        commandCenter().playCommand.addTarget(self, action: #selector(play))
        commandCenter().pauseCommand.addTarget(self, action: #selector(pause))
        commandCenter().nextTrackCommand.addTarget(self, action: #selector(nextTrack))
        commandCenter().previousTrackCommand.addTarget(self, action: #selector(prevTrack))
    }
    
    private func removeRemoteCommands() {
        commandCenter().playCommand.removeTarget(self)
        commandCenter().pauseCommand.removeTarget(self)
        commandCenter().nextTrackCommand.removeTarget(self)
        commandCenter().previousTrackCommand.removeTarget(self)
    }
    
    private func remoteCommands(isEnabled: Bool) {
        commandCenter().playCommand.isEnabled = isEnabled
        commandCenter().pauseCommand.isEnabled = isEnabled
        commandCenter().nextTrackCommand.isEnabled = isEnabled
        commandCenter().previousTrackCommand.isEnabled = isEnabled
    }
    
    private func nowPlayingCenter() -> MPNowPlayingInfoCenter {
        return MPNowPlayingInfoCenter.default()
    }
    
    private func commandCenter() -> MPRemoteCommandCenter {
        return MPRemoteCommandCenter.shared()
    }
    
    private func loadTrackByID(_ trackID: String) {
        guard let keys = AuthManager.s.getAuthKeys() else { return }
        APIManager.s.audioGet(keys: keys, ids: trackID) { [weak self] error, data in
            guard let `self` = self, let data = data, data.list.count > 0 else { return }
            self.setTrack(data.list[0])
        }
    }
    
    private  func setTrack(_ track: AudioData) {
        guard let trackLink = track.track, let trackURL = URL(string: trackLink) else { return }
        playerListenerOne?.blockControl()
        playerListenerTwo?.blockControl()
        remoteCommands(isEnabled: false)
        removePlayStatusObserver()
        removePlayerRateObserver()
        player = nil
        currentTrack = nil
        
        currentTrack = CurrentTrack(id: track.id, title: track.title, performer: track.performer, duration: track.duration, image: nil)
        playerListenerOne?.trackInfoChanged(currentTrack!)
        playerListenerTwo?.trackInfoChanged(currentTrack!)
        nowPlayingCenter().nowPlayingInfo?[MPMediaItemPropertyTitle] = track.title
        nowPlayingCenter().nowPlayingInfo?[MPMediaItemPropertyArtist] = track.performer
        if SettingsManager.s.loadImages! {
            RemoteDataManager.s.getData(link: track.images.last ?? "") { [weak self] imageData in
                guard let `self` = self, track.id == self.currentTrack?.id, let image = UIImage(data: imageData as Data) else { return }
                self.currentTrack?.image = image
                self.playerListenerOne?.trackImageChanged(imageData as Data)
                self.playerListenerTwo?.trackImageChanged(imageData as Data)
                self.nowPlayingCenter().nowPlayingInfo?[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { _ in return image }
            }
        }
        // https://andreygordeev.com/2018/03/31/cache-avplayeritem/
        // https://github.com/neekeetab/CachingPlayerItem
        player = AVPlayer(playerItem: AVPlayerItem(url: trackURL) /* CachingPlayerItem(url: trackURL) */)
        player?.automaticallyWaitsToMinimizeStalling = false
        addPlayStatusObserver()
        addPlayerRateObserver()
    }
    
    public func clearPlayer() {
        playerListenerOne?.playlistRemoved()
        playerListenerTwo?.playlistRemoved()
        removePlayStatusObserver()
        removePlayerRateObserver()
        player = nil
        currentTrack = nil
        playlist = nil
        nowPlayingCenter().nowPlayingInfo?[MPMediaItemPropertyTitle] = nil
        nowPlayingCenter().nowPlayingInfo?[MPMediaItemPropertyArtist] = nil
        nowPlayingCenter().nowPlayingInfo?[MPMediaItemPropertyArtwork] = nil
        removeRemoteCommands()
    }
    
    public func setPlaylist(tracksIDs: [String], current: Int = 0) {
        playlist = Playlist(IDs: tracksIDs, current: current)
        loadTrackByID(playlist!.curr())
        playerListenerOne?.playlistAdded(playlist!)
        playerListenerTwo?.playlistAdded(playlist!)
        addRemoteCommands()
    }
   
    public func getRealCurrentTime() -> Double? {
        return player?.currentItem?.currentTime().seconds
    }
    
    public func getRealDuration() -> Double? {
        return player?.currentItem?.duration.seconds
    }
    
    @objc public func nextTrack() {
        guard let _ = self.playlist else { return }
        loadTrackByID(self.playlist!.next())
    }
    
    @objc public func prevTrack() {
        guard let _ = self.playlist else { return }
        loadTrackByID(self.playlist!.prev())
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
    
    public func playOrPause() {
        if player?.rate == 0 { play() } else { pause() }
    }
    
    public func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool = false) {
        guard let player = player, let currentItem = player.currentItem else { return }
        player.seek(to: CMTimeMake(Int64(withCurrentTime ? currentItem.currentTime().seconds + sec : sec), 1))
    }
    
    public func playerRate() -> Float? {
        return player?.rate
    }
    
}
