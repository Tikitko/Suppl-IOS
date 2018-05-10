import Foundation
import UIKit

class SmallPlayerViewController: UIViewController, SmallPlayerViewControllerProtocol {
    
    var presenter: SmallPlayerPresenterProtocol!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var openPlayerButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        clearPlayer()
        view.isOpaque = true
        view.alpha = 0
    }
    
    func showPlayer() {
        playerAlpha(1)
    }
    
    func closePlayer() {
        playerAlpha(0)
    }
    
    func playerAlpha(_ alpha: Float) {
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = CGFloat(alpha)
        }, completion: nil)
    }
    
    func setTheme() {
        view.theme_backgroundColor = "secondColor"
        progressBar.theme_tintColor = "thirdColor"
    }
    
    func setTrackInfo(title: String, performer: String) {
        titleLabel.text = "\(performer) - \(title)"
    }
    
    func setTrackImage(_ imageData: Data) {
        guard let image = UIImage(data: imageData) else { return }
        imageView.image = image
    }
    
    func openPlayer() {
        progressBar.progress = 0
        playButton.isEnabled = true

    }
    
    func updatePlayerProgress(percentages: Float) {
        progressBar.setProgress(percentages, animated: true)
    }
    
    
    func clearPlayer() {
        imageView.image = #imageLiteral(resourceName: "cd")
        titleLabel.text = nil
        progressBar.progress = 0
        playButton.isEnabled = false
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
    
    @IBAction func playButtonClicked(_ sender: Any) {
        presenter.play()
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        presenter.removePlayer()
    }
    
    @IBAction func openPlayerButtonClicked(_ sender: Any) {
        presenter.openBigPlayer()
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        presenter.navButtonClick(next: false)
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        presenter.navButtonClick(next: true)
    }
    
}
