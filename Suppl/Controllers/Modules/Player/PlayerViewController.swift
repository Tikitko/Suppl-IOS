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
    
    private var player: AVPlayer?
    
    private var tracks: [AudioData]? = nil
    
    convenience init(tracks: [AudioData]) {
        self.init(nibName: nil, bundle: nil)
        self.tracks = tracks
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        navigationItem.title = "Проигрыватель"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performerLabel.text = ""
        titleLabel.text = ""
        progressSlider.value = 0
        goneLabel.text = "0:00"
        leftLabel.text = "0:00"
        
        guard let ikey = UserDefaultsManager.identifierKey, let akey = UserDefaultsManager.accessKey, let tracks = tracks else { return }
        APIManager.audioGet(ikey: ikey, akey: akey, ids: tracks[0].id) { [weak self] error, data in
            guard let `self` = self, let data = data else { return }
            self.setPlayerTrack(track: data.list[0])
        }
    }
    
    private func secondsToMinutesSeconds (seconds : Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    private func formatTime(sec: Int) -> String {
        let minSec = self.secondsToMinutesSeconds(seconds: sec)
        let min = String(minSec.0)
        let sec = (minSec.1 < 10 ? "0" : "") + String("\(minSec.1)")
        return String("\(min):\(sec)")
    }
    
    private func setPlayerTrack(track: AudioData) {
        guard let trackLink = track.track, let trackURL = URL(string: trackLink) else { return }
        
        titleLabel.text = track.title
        performerLabel.text = track.performer
        ImagesManager.getImage(link: track.images.last ?? "") { [weak self] image in
            guard let `self` = self else { return }
            self.imageView.image = image
        }
        
        let playerItem = AVPlayerItem(url: trackURL)
        let player = AVPlayer(playerItem: playerItem)
        self.player = player

        progressSlider.minimumValue = 0
        progressSlider.maximumValue = Float(playerItem.asset.duration.seconds)
        progressSlider.value = 0
        progressSlider.isContinuous = false
        
        goneLabel.text = formatTime(sec: Int(progressSlider.minimumValue))
        leftLabel.text = formatTime(sec: Int(progressSlider.maximumValue))
        
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { [weak self] (CMTime) -> Void in
            guard let `self` = self, let player = self.player, player.currentItem?.status == .readyToPlay else { return }
            self.progressSlider.value = Float(player.currentTime().seconds)
            self.goneLabel.text = self.formatTime(sec: Int(self.progressSlider.value))
            self.leftLabel.text = self.formatTime(sec: Int(self.progressSlider.maximumValue - self.progressSlider.value))
            if Int(self.progressSlider.maximumValue - self.progressSlider.value) == 0 {
                self.pause()
            }
        }
        
        pause()
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        guard let player = player else { return }
        player.seek(to: CMTimeMake(Int64(progressSlider.value), 1))
        if player.rate == 0 { play() }
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
    
}
