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
    private var currentTrack: CurrentTrack?
    
    public weak var playerListener: PlayerListenerDelegate?
    
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
        case #keyPath(AVPlayerItem.status):
            observePlayerItemStatus(statusNumber)
        case #keyPath(AVPlayer.rate):
            observePlayerRate(statusNumber)
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
                self.playerListener?.curentTrackTime(sec: player.currentTime().seconds)
            }
            playerListener?.openControl()
            play()
        case .failed: break
        case .unknown: break
        }
    }
    
    private func observePlayerRate(_ statusNumber: NSNumber?) {
        let rate: Float = statusNumber?.floatValue ?? -1.0
        if rate == 1.0 {
            playerListener?.playerPlay()
        } else if rate == 0.0 {
            playerListener?.playerStop()
            guard let currentItem = player?.currentItem else { return }
            if SettingsManager.s.autoNextTrack!, Int(currentItem.duration.seconds - currentItem.currentTime().seconds) == 0, let _ = playlist {
                loadTrackByID(playlist!.next())
            } else if needPlayingStatus {
                player?.play()
            }
        }
    }

    /*
    private func addNowPlayingInfoCenter(title:String?, performer: String?) {
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title ?? ""
        nowPlayingInfo[MPMediaItemPropertyArtist] = performer ?? ""
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    private func addRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget() { [weak self] event in
            guard let `self` = self else { return MPRemoteCommandHandlerStatus.commandFailed }
            self.play()
            return MPRemoteCommandHandlerStatus.success
        }
        commandCenter.pauseCommand.addTarget() { [weak self] event in
            guard let `self` = self else { return MPRemoteCommandHandlerStatus.commandFailed }
            self.pause()
            return MPRemoteCommandHandlerStatus.success
        }
        commandCenter.nextTrackCommand.addTarget() { [weak self] event in
            guard let `self` = self else { return MPRemoteCommandHandlerStatus.commandFailed }
            self.nextTrack()
            return MPRemoteCommandHandlerStatus.success
        }
        commandCenter.previousTrackCommand.addTarget() { [weak self] event in
            guard let `self` = self else { return MPRemoteCommandHandlerStatus.commandFailed }
            self.prevTrack()
            return MPRemoteCommandHandlerStatus.success
        }
    }
    */
    
    private func loadTrackByID(_ trackID: String) {
        guard let keys = AuthManager.s.getAuthKeys() else { return }
        APIManager.s.audioGet(keys: keys, ids: trackID) { [weak self] error, data in
            guard let `self` = self, let data = data, data.list.count > 0 else { return }
            self.setTrack(data.list[0])
        }
    }
    
    private func clearPlayer() {
        playerListener?.playlistRemoved()
        removePlayStatusObserver()
        removePlayerRateObserver()
        player = nil
        currentTrack = nil
        playlist = nil
    }
    
    private  func setTrack(_ track: AudioData) {
        guard let trackLink = track.track, let trackURL = URL(string: trackLink) else { return }
        playerListener?.blockControl()
        removePlayStatusObserver()
        removePlayerRateObserver()
        player = nil
        currentTrack = nil
        
        let tempTrackId = track.id
        currentTrack = CurrentTrack(id: track.id, title: track.title, performer: track.performer, duration: track.duration, image: nil)
        playerListener?.trackInfoChanged(currentTrack!)
        //addNowPlayingInfoCenter(title: track.title, performer: track.performer)
        if SettingsManager.s.loadImages! {
            RemoteDataManager.s.getData(link: track.images.last ?? "") { [weak self] imageData in
                guard let `self` = self, tempTrackId == self.currentTrack?.id else { return }
                self.currentTrack?.image = UIImage(data: imageData as Data)
                self.playerListener?.trackImageChanged(imageData as Data)
            }
        }
        player = AVPlayer(playerItem: AVPlayerItem(url: trackURL))
        player?.automaticallyWaitsToMinimizeStalling = false
        addPlayStatusObserver()
        addPlayerRateObserver()
    }
    
    
    
    
    public func setPlaylist(tracksIDs: [String], current: Int = 0) {
        playlist = Playlist(IDs: tracksIDs, current: current)
        loadTrackByID(playlist!.curr())
        playerListener?.playlistAdded(playlist!)
        //addRemoteCommandCenter()
    }
   
    public func getRealCurrentTime() -> Double? {
        return player?.currentItem?.currentTime().seconds
    }
    
    public func getRealDuration() -> Double? {
        return player?.currentItem?.duration.seconds
    }
    
    public func nextTrack() {
        guard let _ = self.playlist else { return }
        loadTrackByID(self.playlist!.next())
    }
    
    public func prevTrack() {
        guard let _ = self.playlist else { return }
        loadTrackByID(self.playlist!.prev())
    }
    
    public func play() {
        guard let player = player, let currentItem = player.currentItem else { return }
        if Int(currentItem.duration.seconds - currentItem.currentTime().seconds) == 0 {
            setPlayerCurrentTime(0)
        }
        needPlayingStatus = true
        player.play()
    }
    
    public func pause() {
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
    
}
