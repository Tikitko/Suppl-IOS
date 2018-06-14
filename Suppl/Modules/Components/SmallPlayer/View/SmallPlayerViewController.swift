import Foundation
import UIKit

class SmallPlayerViewController: UIViewController, SmallPlayerViewControllerProtocol {
    
    var presenter: SmallPlayerPresenterProtocolView!
    
    enum ShowType {
        case closed
        case opened
        case partOpened
    }
    
    @IBOutlet weak var smallPlayerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var openPlayerButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var titleLabelBig: UILabel!
    @IBOutlet weak var performerLabelBig: UILabel!
    @IBOutlet weak var imageViewBig: UIImageView!
    @IBOutlet weak var playButtonBig: UIButton!
    @IBOutlet weak var rewindMButtonBig: UIButton!
    @IBOutlet weak var rewindPButtonBig: UIButton!
    @IBOutlet weak var goneLabelBig: UILabel!
    @IBOutlet weak var leftLabelBig: UILabel!
    @IBOutlet weak var progressSliderBig: UISlider!
    @IBOutlet weak var backButtonBig: UIButton!
    @IBOutlet weak var nextButtonBig: UIButton!
    @IBOutlet weak var closeButtonBig: UIButton!
    
    var nowShowType: ShowType = .closed
    var closed: CGFloat = 0
    var opened: CGFloat = 0
    var partOpened: CGFloat = 0
    var parentTabBar: UITabBar? {
        get { return (view.superview?.parentViewController as? UITabBarController)?.tabBar }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setListener()
        setTheme()
        clearPlayer()
        smallPlayerView.isOpaque = true
        parentTabBar?.isOpaque = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPlayerShow(type: nowShowType)
    }
    
    func setPlayerShowAnimated(type: ShowType) {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.setPlayerShow(type: type, needClear: false)
        }) { [weak self] status in
            if status && type == .closed {
                self?.clearPlayer()
            }
        }
    }
    
    func updateTopMargin(_ margin: CGFloat? = nil) {
        if let safeAreaMarginConstraintIndex = view.constraints.index(where: { $0.identifier == "safeAreaMargin" }) {
            view.constraints[safeAreaMarginConstraintIndex].constant = margin ?? view.superview?.safeAreaInsets.top ?? 0
            view.layoutIfNeeded()
        }
    }
    
    func setPlayerShow(type: ShowType, needClear: Bool = true) {
        let result: CGFloat
        switch type {
        case .closed:
            result = closed
            smallPlayerView.alpha = 1
            parentTabBar?.alpha = 1
            updateTopMargin(0)
        case .opened:
            result = opened
            smallPlayerView.alpha = 0
            parentTabBar?.alpha = 0
            updateTopMargin()
        case .partOpened:
            result = partOpened
            smallPlayerView.alpha = 1
            parentTabBar?.alpha = 1
            updateTopMargin(0)
        }
        nowShowType = type
        view.frame.origin.y = result
        if needClear && type == .closed {
            clearPlayer()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let tabBarHeight: CGFloat = parentTabBar?.frame.height ?? 0
        closed = (view.superview?.frame.height ?? view.frame.height) - tabBarHeight
        partOpened = closed - smallPlayerView.frame.height
        opened = view.superview?.frame.origin.y ?? 0
        setPlayerShow(type: nowShowType)
    }
    
    func setTheme() {
        view.theme_backgroundColor = "thirdColor"
        smallPlayerView.theme_backgroundColor = "secondColor"
        progressBar.theme_tintColor = "thirdColor"
    }
    
    func setTrackInfo(title: String, performer: String) {
        titleLabel.text = "\(performer) - \(title)"
        titleLabelBig.text = title
        performerLabelBig.text = performer
    }
    
    func setTrackImage(_ imageData: Data) {
        guard let image = UIImage(data: imageData) else { return }
        imageView.image = image
        imageViewBig.image = image
    }
    
    func openPlayer(duration: Double) {
        progressBar.progress = 0
        playButton.isEnabled = true

        progressSliderBig.minimumValue = 0
        progressSliderBig.maximumValue = Float(duration)
        progressSliderBig.value = 0
        
        goneLabelBig.text = TrackTime(sec: Int(progressSliderBig.minimumValue)).formatted
        leftLabelBig.text = TrackTime(sec: Int(progressSliderBig.maximumValue)).formatted
        
        playButtonBig.isEnabled = true
        rewindMButtonBig.isEnabled = true
        rewindPButtonBig.isEnabled = true
        progressSliderBig.isEnabled = true
    }
    
    func updatePlayerProgress(percentages: Float, currentTime: Double) {
        progressBar.setProgress(percentages, animated: true)
        progressSliderBig.value = Float(currentTime)
        goneLabelBig.text = TrackTime(sec: Int(progressSliderBig.value)).formatted
        leftLabelBig.text = TrackTime(sec: Int(progressSliderBig.maximumValue - progressSliderBig.value)).formatted
    }
    
    
    func clearPlayer() {
        setPlayImage()
        imageView.image = #imageLiteral(resourceName: "cd")
        titleLabel.text = nil
        progressBar.progress = 0
        playButton.isEnabled = false
        
        imageViewBig.image = #imageLiteral(resourceName: "cd")
        performerLabelBig.text = nil
        titleLabelBig.text = nil
        progressSliderBig.minimumValue = 0
        progressSliderBig.maximumValue = 1
        progressSliderBig.value = 0
        goneLabelBig.text = TrackTime(sec: 0).formatted
        leftLabelBig.text = TrackTime(sec: 0).formatted
        playButtonBig.isEnabled = false
        rewindMButtonBig.isEnabled = false
        rewindPButtonBig.isEnabled = false
        progressSliderBig.isEnabled = false

    }
    
    func setPlayButtonImage(_ image: UIImage) {
        playButton.setImage(image, for: .normal)
        playButtonBig.setImage(image, for: .normal)
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
        setPlayerShowAnimated(type: .opened)
    }
    
    @IBAction func closePlayerButtonClicked(_ sender: Any) {
        setPlayerShowAnimated(type: .partOpened)
    }
    
    @IBAction func backButtonClick(_ sender: Any) {
        presenter.navButtonClick(next: false)
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        presenter.navButtonClick(next: true)
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        presenter.setPlayerCurrentTime(Double(progressSliderBig.value), withCurrentTime: false)
    }
    
    @IBAction func rewindPClicked(_ sender: Any) {
        presenter.rewindP()
    }
    
    @IBAction func rewindMClicked(_ sender: Any) {
        presenter.rewindM()
    }
    
}
