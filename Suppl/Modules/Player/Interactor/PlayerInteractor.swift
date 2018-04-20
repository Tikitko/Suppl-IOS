import Foundation
import AVFoundation
import AVKit
import MediaPlayer

class PlayerInteractor: NSObject, PlayerInteractorProtocol {
    weak var presenter: PlayerPresenterProtocol!
    
    var needPlayingStatus = false
    
    var observerPlayStatusWorking = false
    var observerPlayerRateWorking = false
    
    var tracks: TrackList?
    var player: AVPlayer?
    
    init(tracksIDs: [String], current: Int = 0) {
        tracks = TrackList.get(IDs: tracksIDs, current: current)
    }
    
    func clearPlayer() {
        player = nil
    }
    
    func addPlayStatusObserver() {
        if observerPlayStatusWorking { return }
        observerPlayStatusWorking = true
        player?.currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.new, .old], context: nil)
    }
    
    func removePlayStatusObserver() {
        if !observerPlayStatusWorking { return }
        player?.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        observerPlayStatusWorking = false
    }
    
    func addPlayerRateObserver() {
        if observerPlayerRateWorking { return }
        observerPlayerRateWorking = true
        player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate), options: [.new, .old], context: nil)
    }
    
    func removePlayerRateObserver() {
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
    
    func addPlayerTimeObserver() {
        player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { [weak self] (CMTime) -> Void in
            guard let `self` = self, let player = self.player, player.currentItem?.status == .readyToPlay else { return }
            self.presenter.updatePlayerProgress(currentTime: player.currentTime().seconds)
        }
    }
    
    func observePlayerItemStatus(_ statusNumber: NSNumber?) {
        removePlayStatusObserver()
        let status: AVPlayerItemStatus = AVPlayerItemStatus(rawValue: statusNumber?.intValue ?? AVPlayerItemStatus.unknown.rawValue)!
        switch status {
        case .readyToPlay:
            guard let player = player, let currentItem = player.currentItem else { break }
            presenter.openPlayer(duration: currentItem.duration.seconds)
            needPlayingStatus = true
            player.play()
        case .failed: break
        case .unknown: break
        }
    }
    
    func observePlayerRate(_ statusNumber: NSNumber?) {
        let rate: Float = statusNumber?.floatValue ?? -1.0
        if rate == 1.0 {
            presenter.setPlayButtonImage(UIImage(named: "icon_154.png")!)
        } else if rate == 0.0 {
            presenter.setPlayButtonImage(UIImage(named: "icon_152.png")!)
            autoPlayHandler()
        }
    }
    
    func autoPlayHandler() {
        guard let currentItem = player?.currentItem else { return }
        if SettingsManager.autoNextTrack!, Int(currentItem.duration.seconds - currentItem.currentTime().seconds) == 0, let _ = tracks {
            clearPlayer()
            loadTrackByID(tracks!.next())
        } else if needPlayingStatus {
            player?.play()
        }
    }
    
    func addNowPlayingInfoCenter(title:String?, performer: String?) {
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title ?? ""
        nowPlayingInfo[MPMediaItemPropertyArtist] = performer ?? ""
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    func addRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget() { [weak self] event in
            guard let `self` = self else { return MPRemoteCommandHandlerStatus.commandFailed }
            self.needPlayingStatus = true
            self.player?.play()
            return MPRemoteCommandHandlerStatus.success
        }
        commandCenter.pauseCommand.addTarget() { [weak self] event in
            guard let `self` = self else { return MPRemoteCommandHandlerStatus.commandFailed }
            self.needPlayingStatus = false
            self.player?.pause()
            return MPRemoteCommandHandlerStatus.success
        }
        commandCenter.nextTrackCommand.addTarget() { [weak self] event in
            guard let `self` = self, let _ = self.tracks else { return MPRemoteCommandHandlerStatus.commandFailed }
            self.loadTrackByID(self.tracks!.next())
            return MPRemoteCommandHandlerStatus.success
        }
        commandCenter.previousTrackCommand.addTarget() { [weak self] event in
            guard let `self` = self, let _ = self.tracks else { return MPRemoteCommandHandlerStatus.commandFailed }
            self.loadTrackByID(self.tracks!.prev())
            return MPRemoteCommandHandlerStatus.success
        }
    }
    
    func loadTrackByID(_ trackID: String) {
        guard let (ikey, akey) = AuthManager.getAuthKeys() else { return }
        APIManager.audioGet(ikey: ikey, akey: akey, ids: trackID) { [weak self] error, data in
            guard let `self` = self, let data = data, data.list.count > 0 else { return }
            let track = data.list[0]
            self.setTrack(track)
            self.addNowPlayingInfoCenter(title: track.title, performer: track.performer)
        }
        addRemoteCommandCenter()
    }
    
    func setTrack(_ track: AudioData) {
        guard let trackLink = track.track, let trackURL = URL(string: trackLink) else { return }
        presenter.clearPlayer()
        setTrackInfo(track)
        player = AVPlayer(playerItem: AVPlayerItem(url: trackURL))
        player?.automaticallyWaitsToMinimizeStalling = false
        presenter.startObservers()
    }
    
    func setTrackInfo(_ track: AudioData) {
        presenter.setTrackInfo(title: track.title, performer: track.performer)
        ImagesManager.getImage(link: track.images.last ?? "") { [weak self] image in
            guard let `self` = self else { return }
            self.presenter.setTrackImage(image)
            
        }
    }
    
    func play() {
        guard let player = player, let currentItem = player.currentItem else { return }
        guard player.rate == 0 else {
            needPlayingStatus = false
            player.pause()
            return
        }
        if Int(currentItem.duration.seconds - currentItem.currentTime().seconds) == 0 {
            setPlayerCurrentTime(0)
        }
        needPlayingStatus = true
        player.play()
    }
    
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool = false) {
        guard let currentItem = player?.currentItem else { return }
        player?.seek(to: CMTimeMake(Int64(withCurrentTime ? currentItem.currentTime().seconds + sec : sec), 1))
    }
}
