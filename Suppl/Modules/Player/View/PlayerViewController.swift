import Foundation
import UIKit
import SwiftTheme

class PlayerViewController: UIViewController, PlayerViewControllerProtocol {
    
    var presenter: PlayerPresenterProtocolView!
    
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
    
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setListener()
        setTheme()
        clearPlayer()
        presenter.firstLoad()
    }
    
    func setTheme() {
        view.theme_backgroundColor = "thirdColor"
    }
    
    func setNavTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func setTrackInfo(title: String, performer: String) {
        titleLabel.text = title
        performerLabel.text = performer
    }
    
    func setTrackImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    func setTrackImage(_ imageData: Data) {
        imageView.image = UIImage(data: imageData)
    }
    
    func openPlayer(duration: Double) {
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = Float(duration)
        progressSlider.value = 0
        
        goneLabel.text = TrackTime(sec: Int(progressSlider.minimumValue)).formatted
        leftLabel.text = TrackTime(sec: Int(progressSlider.maximumValue)).formatted
        
        playButton.isEnabled = true
        rewindMButton.isEnabled = true
        rewindPButton.isEnabled = true
        progressSlider.isEnabled = true
    }
    
    func updatePlayerProgress(currentTime: Double) {
        progressSlider.value = Float(currentTime)
        goneLabel.text = TrackTime(sec: Int(progressSlider.value)).formatted
        leftLabel.text = TrackTime(sec: Int(progressSlider.maximumValue - progressSlider.value)).formatted
    }
    
    func clearPlayer() {
        imageView.image = #imageLiteral(resourceName: "cd")
        performerLabel.text = nil
        titleLabel.text = nil
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = 1
        progressSlider.value = 0
        goneLabel.text = TrackTime(sec: 0).formatted
        leftLabel.text = TrackTime(sec: 0).formatted
        
        playButton.isEnabled = false
        rewindMButton.isEnabled = false
        rewindPButton.isEnabled = false
        progressSlider.isEnabled = false
    }
    
    func setPlayButtonImage(_ image: UIImage) {
        playButton.setImage(image, for: .normal)
    }
    
    func setPlayImage() {
        setPlayButtonImage(#imageLiteral(resourceName: "icon_152"))
    }
    
    func setPauseImage() {
        setPlayButtonImage(#imageLiteral(resourceName: "icon_154"))
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        presenter.setPlayerCurrentTime(Double(progressSlider.value), withCurrentTime: false)
    }
    
    @IBAction func playButtonClicked(_ sender: Any) {
        presenter.play()
    }
    
    @IBAction func rewindPClicked(_ sender: Any) {
        presenter.rewindP()
    }
    
    @IBAction func rewindMClicked(_ sender: Any) {
        presenter.rewindM()
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        presenter.navButtonClick(next: false)
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        presenter.navButtonClick(next: true)
    }

    @IBAction func closeButtonClick(_ sender: Any) {
        presenter.closePlayer()
    }
}
