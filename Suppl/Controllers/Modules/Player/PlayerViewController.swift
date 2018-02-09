import Foundation
import UIKit
import AVFoundation
import AVKit

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
        clearPlayer()
        guard let tracks = tracks else { return }
        loadTrackByID(tracks.curr())
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
        let player = AVPlayer(playerItem: AVPlayerItem(url: trackURL))
        player.currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.new, .old], context: nil)
        self.player = player
    }
    
    private func setTrackInfo(_ track: AudioData) {
        titleLabel.text = track.title
        performerLabel.text = track.performer
        ImagesManager.getImage(link: track.images.last ?? "") { [weak self] image in
            guard let `self` = self else { return }
            self.imageView.image = image
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItemStatus
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            switch status {
            case .readyToPlay:
                guard let player = player else { break }
                player.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
                openPlayer(player)
                play()
            case .failed: break
            case .unknown: break
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
            if Int(self.progressSlider.maximumValue - self.progressSlider.value) == 0, let tracks = self.tracks {
                self.loadTrackByID(tracks.next())
                //self.pause()
            }
        }
        pause()
        
        playButton.isEnabled = true
        rewindMButton.isEnabled = true
        rewindPButton.isEnabled = true
        progressSlider.isEnabled = true
    }
    
    private func clearPlayer() {
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
    
    private func play() {
        guard let player = player else { return }
        playButton.setImage(UIImage(named: "icon_154.png"), for: .normal)
        player.play()
    }
    
    private func pause() {
        guard let player = player else { return }
        playButton.setImage(UIImage(named: "icon_152.png"), for: .normal)
        player.pause()
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        guard let player = player else { return }
        player.seek(to: CMTimeMake(Int64(progressSlider.value), 1))
    }
    
    @IBAction func playButtonClicked(_ sender: Any) {
        guard let player = player else { return }
        guard player.rate == 0 else {
            pause()
            return
        }
        if Int(progressSlider.value) == Int(progressSlider.maximumValue) {
            player.seek(to: CMTimeMake(0, 1))
        }
        play()
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
    
    
}
