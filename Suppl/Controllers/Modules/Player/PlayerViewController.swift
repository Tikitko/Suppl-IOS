import Foundation
import UIKit
import AVFoundation
import AVKit

class PlayerViewController: UIViewController {
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var performerLabel: UILabel!
    @IBOutlet weak var imageVIew: UIImageView!
    
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
    
    private func secondsToMinutesSeconds (seconds : Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    private func formatTime(sec: Int) -> String {
        let minSec = self.secondsToMinutesSeconds(seconds: sec)
        let min = String(minSec.0)
        let sec = (minSec.1 < 10 ? "0" : "") + String("\(minSec.1)")
        return String("\(min):\(sec)")
    }
    
    private func setPlayerTrack(trackURL: URL) {
        let playerItem:AVPlayerItem = AVPlayerItem(url: trackURL)
        player = AVPlayer(playerItem: playerItem)

        let duration = Float(playerItem.asset.duration.seconds)

        progressSlider.minimumValue = 0
        goneLabel.text = formatTime(sec: 0)
        progressSlider.maximumValue = duration
        leftLabel.text = formatTime(sec: Int(duration))
        progressSlider.isContinuous = false
        progressSlider.value = 0
        
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { [weak self] (CMTime) -> Void in
            guard let `self` = self, let player = self.player else { return }
            if player.currentItem?.status == .readyToPlay {
                let current = Float(player.currentTime().seconds)
                self.progressSlider.value = current;
                self.goneLabel.text = self.formatTime(sec: Int(current))
                self.leftLabel.text = self.formatTime(sec: Int(duration)-Int(current))
                if self.progressSlider.value == self.progressSlider.maximumValue {
                    self.pause()
                }
            }
        }
        
        pause()
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        guard let player = player else { return }
        let seconds : Int64 = Int64(progressSlider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        player.seek(to: targetTime)
        if player.rate == 0
        {
            play()
        }
    }
    
    @IBAction func playButtonClicked(_ sender: Any) {
        guard let player = player else { return }
        if player.rate == 0 {
            if progressSlider.value == progressSlider.maximumValue {
                let targetTime:CMTime = CMTimeMake(0, 1)
                player.seek(to: targetTime)
            }
            play()
        } else {
            pause()
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let ikey = UserDefaultsManager.identifierKey, let akey = UserDefaultsManager.accessKey, let tracks = tracks else { return }
        APIManager.audioGet(ikey: ikey, akey: akey, ids: tracks[0].id) { [weak self] error, data in
            guard let `self` = self, let data = data, let trackURL = URL(string: data.list[0].track!) else { return }
            self.setPlayerTrack(trackURL: trackURL)
        }
    }
    
}
