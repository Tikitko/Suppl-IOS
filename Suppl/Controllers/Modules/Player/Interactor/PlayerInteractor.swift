import Foundation
import AVFoundation
import AVKit
import MediaPlayer
import UIKit

class PlayerInteractor: NSObject, PlayerInteractorProtocol {
    weak var presenter: PlayerPresenterProtocol!
    
    class TracksList {
        private var IDs: [String]
        private var current: Int
        public static func get(IDs: [String], current: Int = 0) -> TracksList? {
            if IDs.count > 0, current < IDs.count {
                return TracksList.init(IDs: IDs, current: current)
            }
            return nil
        }
        private init(IDs: [String], current: Int = 0) {
            self.IDs = IDs
            self.current = current
        }
        public func curr() -> String {
            return IDs[current]
        }
        public func next() -> String {
            current = IDs.count - 1 == current ? 0 : current + 1
            return IDs[current]
        }
        public func prev()  -> String {
            current = 0 == current ? IDs.count - 1 : current - 1
            return IDs[current]
        }
    }
    
    var needPlayingStatus = false
    
    var observerPlayStatusWorking = false
    var observerPlayerRateWorking = false
    
    var tracks: TracksList?
    var player: AVPlayer?
    
    func clearPlayer() {
        player = nil
    }
    
    func setPlayingStatus(_ status: Bool) {
        needPlayingStatus = status
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
        print("inOb")
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
            guard let currentItem = player?.currentItem else { return }
            if SettingsManager.autoNextTrack!, Int(currentItem.duration.seconds - currentItem.currentTime().seconds) == 0, let tracks = tracks {
                clearPlayer()
                loadTrackByID(tracks.next())
            } else if needPlayingStatus {
                player?.play()
            }
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
            guard let `self` = self, let tracks = self.tracks else { return MPRemoteCommandHandlerStatus.commandFailed }
            self.loadTrackByID(tracks.next())
            return MPRemoteCommandHandlerStatus.success
        }
        commandCenter.previousTrackCommand.addTarget() { [weak self] event in
            guard let `self` = self, let tracks = self.tracks else { return MPRemoteCommandHandlerStatus.commandFailed }
            self.loadTrackByID(tracks.prev())
            return MPRemoteCommandHandlerStatus.success
        }
    }
    
    func loadTrackByID(_ trackID: String) {
        guard let (ikey, akey) = AuthManager.getAuthKeys() else { return }
        APIManager.audioGet(ikey: ikey, akey: akey, ids: trackID) { [weak self] error, data in
            guard let `self` = self, let data = data, data.list.count > 0 else { return }
            self.setTrack(data.list[0])
        }
    }
    
    func setTrack(_ track: AudioData) {
        guard let trackLink = track.track, let trackURL = URL(string: trackLink) else { return }
        presenter.clearPlayer()
        setTrackInfo(track)
        player = AVPlayer(playerItem: AVPlayerItem(url: trackURL))
        presenter.startObservers()
        player?.automaticallyWaitsToMinimizeStalling = false
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
