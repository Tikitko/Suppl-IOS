import Foundation
import UIKit
import AVFoundation
import AVKit
import MediaPlayer
import SwiftTheme

class PlayerViewController: UIViewController {
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var performerLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var rewindMButton: UIButton!
    @IBOutlet weak var rewindPButton: UIButton!
    
    @IBOutlet weak var goneLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    private class TracksList {
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
    
    private var needPlayingStatus = false
    
    private var observerPlayStatusWorking = false
    private var observerPlayerRateWorking = false
    
    private var tracks: TracksList?
    private var player: AVPlayer?
    
    convenience init(tracksIDs: [String], current: Int = 0) {
        self.init(nibName: nil, bundle: nil)
        tracks = TracksList.get(IDs: tracksIDs, current: current)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        navigationItem.title = "Плеер"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        clearPlayer()
        guard let tracks = tracks else { return }
        loadTrackByID(tracks.curr())
    }
    
    func setTheme() {
        //view.backgroundColor = AppData.getTheme(SettingsManager.theme).thirdColor
        view.theme_backgroundColor = "thirdColor"
    }
    
    private func loadTrackByID(_ trackID: String) {
        guard let ikey = UserDefaultsManager.identifierKey, let akey = UserDefaultsManager.accessKey else { return }
        APIManager.audioGet(ikey: ikey, akey: akey, ids: trackID) { [weak self] error, data in
            guard let `self` = self, let data = data, data.list.count > 0 else { return }
            self.setTrack(data.list[0])
        }
    }
    
    private func setTrack(_ track: AudioData) {
        guard let trackLink = track.track, let trackURL = URL(string: trackLink) else { return }
        clearPlayer()
        setTrackInfo(track)
        player = AVPlayer(playerItem: AVPlayerItem(url: trackURL))
        player?.automaticallyWaitsToMinimizeStalling = false
        addPlayStatusObserver()
        addPlayerRateObserver()
        
    }
    
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
    
    private func setTrackInfo(_ track: AudioData) {
        titleLabel.text = track.title
        performerLabel.text = track.performer
        ImagesManager.getImage(link: track.images.last ?? "") { [weak self] image in
            guard let `self` = self else { return }
            self.imageView.image = image
        }
        addNowPlayingInfoCenter()
        addRemoteCommandCenter()
    }
    
    private func addNowPlayingInfoCenter() {
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo ?? [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = titleLabel.text ?? ""
        nowPlayingInfo[MPMediaItemPropertyArtist] = performerLabel.text ?? ""
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
    
    private func addRemoteCommandCenter() {
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

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            removePlayStatusObserver()
            let status: AVPlayerItemStatus
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            switch status {
            case .readyToPlay:
                guard let player = player else { break }
                openPlayer(player)
                needPlayingStatus = true
                player.play()
            case .failed: break
            case .unknown: break
            }
        }
        
        if keyPath == #keyPath(AVPlayer.rate) {
            var rate: Float = 0.0
            if let statusNumber = change?[.newKey] as? Float {
                rate = statusNumber
            }
            if rate == 1.0 {
                playButton.setImage(UIImage(named: "icon_154.png"), for: .normal)
            } else if rate == 0.0 {
                playButton.setImage(UIImage(named: "icon_152.png"), for: .normal)
                if SettingsManager.autoNextTrack!, Int(self.progressSlider.maximumValue - self.progressSlider.value) == 0, let tracks = tracks {
                    clearPlayer()
                    loadTrackByID(tracks.next())
                } else if needPlayingStatus {
                    player?.play()
                }
            }
        }
    }
    
    private func openPlayer(_ player: AVPlayer) {
        guard let currentItem = player.currentItem else { return }
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = Float(currentItem.asset.duration.seconds)
        progressSlider.value = 0
        
        goneLabel.text = TrackTableCell.formatTime(sec: Int(progressSlider.minimumValue))
        leftLabel.text = TrackTableCell.formatTime(sec: Int(progressSlider.maximumValue))
        
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { [weak self] (CMTime) -> Void in
            guard let `self` = self, let player = self.player, player.currentItem?.status == .readyToPlay else { return }
            self.progressSlider.value = Float(player.currentTime().seconds)
            self.goneLabel.text = TrackTableCell.formatTime(sec: Int(self.progressSlider.value))
            self.leftLabel.text = TrackTableCell.formatTime(sec: Int(self.progressSlider.maximumValue - self.progressSlider.value))
        }
        
        playButton.isEnabled = true
        rewindMButton.isEnabled = true
        rewindPButton.isEnabled = true
        progressSlider.isEnabled = true
    }
    
    private func clearPlayer() {
        needPlayingStatus = false
        removePlayStatusObserver()
        removePlayerRateObserver()
        player = nil
        imageView.image = nil
        performerLabel.text = nil
        titleLabel.text = nil
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = 1
        progressSlider.value = 0
        goneLabel.text = "0:00"
        leftLabel.text = "0:00"
        
        playButton.isEnabled = false
        rewindMButton.isEnabled = false
        rewindPButton.isEnabled = false
        progressSlider.isEnabled = false
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        guard let player = player else { return }
        player.seek(to: CMTimeMake(Int64(progressSlider.value), 1))
    }
    
    @IBAction func playButtonClicked(_ sender: Any) {
        guard let player = player else { return }
        guard player.rate == 0 else {
            needPlayingStatus = false
            player.pause()
            return
        }
        if Int(progressSlider.value) == Int(progressSlider.maximumValue) {
            player.seek(to: CMTimeMake(0, 1))
        }
        needPlayingStatus = true
        player.play()
    }
    
    @IBAction func rewindPClicked(_ sender: Any) {
        guard let player = player else { return }
        player.seek(to: CMTimeMake(Int64(player.currentTime().seconds + 15), 1))
    }
    
    @IBAction func rewindMClicked(_ sender: Any) {
        guard let player = player else { return }
        player.seek(to: CMTimeMake(Int64(player.currentTime().seconds - 15), 1))
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        guard let tracks = tracks else { return }
        loadTrackByID(tracks.prev())
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        guard let tracks = tracks else { return }
        loadTrackByID(tracks.next())
    }
    
    deinit {
        removePlayStatusObserver()
        removePlayerRateObserver()
    }
    
}
