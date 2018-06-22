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
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    @IBOutlet weak var playerTitleLabelBig: UILabel!
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
    
    var marginsUpdating = false
    
    let safeAreaMarginIdentifier = "safeAreaMargin"
    var baseMargin: CGFloat = 0
    var nowShowType: ShowType = .closed
    var closed: CGFloat = 0
    var opened: CGFloat = 0
    var partOpened: CGFloat = 0
    var parentTabBar: UITabBar? {
        get { return (view.superview?.parentViewController as? UITabBarController)?.tabBar }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerTitleLabelBig.text = presenter.getTitle()
        playerTitleLabelBig.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerAction(_:))))
        infoStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerAction(_:))))
        
        if let safeAreaMarginConstraintIndex = view.constraints.index(where: { $0.identifier == safeAreaMarginIdentifier }) {
            baseMargin = view.constraints[safeAreaMarginConstraintIndex].constant
        }
        presenter.setListener()
        setTheme()
        clearPlayer()
        imageViewBig.layer.cornerRadius = 10
        imageViewBig.clipsToBounds = true
        smallPlayerView.isOpaque = true
        parentTabBar?.isOpaque = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setPlayerShow(type: nowShowType)
    }
    
    func updateTopMargin(_ margin: CGFloat? = nil, withBase: Bool = true) {
        guard let safeAreaMarginConstraintIndex = view.constraints.index(where: { $0.identifier == safeAreaMarginIdentifier }) else { return }
        let safeAreaMargin: CGFloat?
        if #available(iOS 11.0, *) {
            safeAreaMargin = view.superview?.safeAreaInsets.top
        } else {
            safeAreaMargin = view.superview?.parentViewController?.topLayoutGuide.length
        }
        view.constraints[safeAreaMarginConstraintIndex].constant = margin ?? safeAreaMargin ?? 0
        if withBase {
            view.constraints[safeAreaMarginConstraintIndex].constant += baseMargin
        }
        view.layoutIfNeeded()
    }
    
    func setPlayerShowAnimated(type: ShowType) {
        startExtraPart(showType: type)
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.setPlayerShow(type: type, needExtraPart: false)
        }) { [weak self] status in
            self?.finalExtraPart(showType: type)
        }
    }
    
    func setPlayerShow(type: ShowType, needExtraPart: Bool = true) {
        if needExtraPart {
            startExtraPart(showType: type)
        }
        switch type {
        case .closed:
            view.frame.origin.y = closed
            smallPlayerView.alpha = 1
            parentTabBar?.alpha = 1
            updateTopMargin(0, withBase: false)
            playerTitleLabelBig.isUserInteractionEnabled = false
            infoStackView.isUserInteractionEnabled = false
        case .opened:
            view.frame.origin.y = opened
            smallPlayerView.alpha = 0
            parentTabBar?.alpha = 0
            updateTopMargin()
            playerTitleLabelBig.isUserInteractionEnabled = true
            infoStackView.isUserInteractionEnabled = false
        case .partOpened:
            view.frame.origin.y = partOpened
            smallPlayerView.alpha = 1
            parentTabBar?.alpha = 1
            updateTopMargin(0, withBase: false)
            playerTitleLabelBig.isUserInteractionEnabled = false
            infoStackView.isUserInteractionEnabled = true
        }
        nowShowType = type
        if needExtraPart {
            finalExtraPart(showType: type)
        }
    }
    
    func startExtraPart(showType: ShowType) {
        if showType == .partOpened {
            //view.isHidden = false
        }
    }
    
    func finalExtraPart(showType: ShowType) {
        if showType == .closed {
            clearPlayer()
            //view.isHidden = true
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateMargins()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] _ in
            if UIDevice.current.userInterfaceIdiom == .pad {
                self?.updateMargins()
            }
        })
        super.viewWillTransition(to: size, with: coordinator)
    }

    func updateMargins() {
        if marginsUpdating { return }
        marginsUpdating = true
        let tabBarHeight: CGFloat = parentTabBar?.frame.height ?? 0
        closed = (view.superview?.frame.height ?? view.frame.height) - tabBarHeight
        partOpened = closed - smallPlayerView.frame.height
        opened = view.superview?.frame.origin.y ?? 0
        setPlayerShow(type: nowShowType)
        marginsUpdating = false
    }
    
    func setTheme() {
        
        view.theme_backgroundColor = "thirdColor"
        smallPlayerView.theme_backgroundColor = "secondColor"
        progressBar.theme_tintColor = "thirdColor"
        imageViewBig.theme_backgroundColor = "secondColor"
        /*
        view.theme_backgroundColor = "secondColor"
        smallPlayerView.theme_backgroundColor = "secondColor"
        progressBar.theme_tintColor = "secondColor"
        imageViewBig.theme_backgroundColor = "thirdColor"
         */
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
    
    @objc func tapGestureRecognizerAction(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else { return }
        setPlayerShowAnimated(type: nowShowType == .opened ? .partOpened : .opened)
    }
    
    @IBAction func playButtonClicked(_ sender: Any) {
        presenter.play()
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        presenter.removePlayer()
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
