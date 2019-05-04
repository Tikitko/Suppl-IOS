import Foundation
import UIKit

class SmallPlayerViewController: UIViewController, SmallPlayerViewControllerProtocol {
    
    private struct Constants {
        static let safeAreaMarginConstraintIdentifier = "safeAreaMargin"
    }
    
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
    @IBOutlet weak var playlistButtonBig: UIButton!
    
    weak var parentRootTabBarController: RootTabBarController!
    
    var tracksTableModule: UITableViewController!
    
    var interactionControllerPresent: SmallPlayerInteractionController?
    var interactionControllerDismiss: SmallPlayerInteractionController?
    
    var marginsUpdating = false
    
    var baseMargin: CGFloat = 0
    var nowShowType: ShowType = .closed
    var closed: CGFloat = 0
    var opened: CGFloat = 0
    var partOpened: CGFloat = 0
    
    var useOldAnimation = false
    
    convenience init(table: UITableViewController) {
        self.init()
        tracksTableModule = table
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitioningDelegate = self
        if useOldAnimation {
            playerTitleLabelBig.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerAction(_:)))
            )
            infoStackView.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerAction(_:)))
            )
        } else {
            interactionControllerPresent = SmallPlayerInteractionController(self, forPresent: true)
            interactionControllerDismiss = SmallPlayerInteractionController(self, forPresent: false)
        }
        playerTitleLabelBig.text = presenter.getTitle()
        view.insertSubview(tracksTableModule.view, belowSubview: playlistButtonBig)
        tracksTableModule.view.includeInside(imageViewBig)
        if let safeAreaMarginConstraintIndex = view.constraints.firstIndex(where: { $0.identifier == Constants.safeAreaMarginConstraintIdentifier }) {
            baseMargin = view.constraints[safeAreaMarginConstraintIndex].constant
        }
        presenter.setListener()
        setTheme()
        clearPlayer()
        tracksTableModule.tableView.layer.cornerRadius = 10
        tracksTableModule.tableView.clipsToBounds = true
        imageViewBig.layer.cornerRadius = 10
        imageViewBig.clipsToBounds = true
        smallPlayerView.isOpaque = true
        parentRootTabBarController.tabBar.isOpaque = true
        turnPlaylist(false, duration: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tracksTableModule.viewWillAppear(animated)
        super.viewWillAppear(animated)
        setPlayerShow(type: nowShowType)
    }
    
    func turnPlaylist(_ isOn: Bool, duration: TimeInterval?) {
        let changes = { self.tracksTableModule.view.alpha = isOn ? 0.95 : 0 }
        duration != nil ? UIView.animate(withDuration: duration!, animations: changes) : changes()
    }
    
    func setInParent(initi: Bool = true) {
        if initi {
            view.frame = parentRootTabBarController.view.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        parentRootTabBarController.view.insertSubview(view, belowSubview: parentRootTabBarController.tabBar)
    }
    
    func updateTopMargin(rootSelf: Bool = false, _ margin: CGFloat? = nil, withBase: Bool = true) {
        guard let safeAreaMarginConstraintIndex = view.constraints.firstIndex(where: { $0.identifier == Constants.safeAreaMarginConstraintIdentifier }) else { return }
        let rootViewController: UIViewController = rootSelf ? self : parentRootTabBarController
        let safeAreaMargin: CGFloat?
        if #available(iOS 11.0, *) {
            safeAreaMargin = rootViewController.view.safeAreaInsets.top
        } else {
            safeAreaMargin = rootViewController.topLayoutGuide.length
        }
        view.constraints[safeAreaMarginConstraintIndex].constant = margin ?? safeAreaMargin ?? 0
        if withBase {
            view.constraints[safeAreaMarginConstraintIndex].constant += baseMargin
        }
        view.layoutIfNeeded()
    }
    
    func setPlayerShowAnimated(type: ShowType) {
        startExtraPart(showType: type)
        UIView.animate(
            withDuration: 0.3,
            animations: { self.setPlayerShow(type: type, needExtraPart: false)},
            completion: { status in self.finalExtraPart(showType: type) }
        )
    }
    
    func setPlayerShow(type: ShowType, needExtraPart: Bool = true, rootSelf: Bool = false) {
        if needExtraPart {
            startExtraPart(showType: type)
        }
        switch type {
        case .closed:
            view.frame.origin.y = closed
            smallPlayerView.alpha = 1
            parentRootTabBarController.tabBar.alpha = 1
            updateTopMargin(rootSelf: rootSelf, 0, withBase: false)
            playerTitleLabelBig.isUserInteractionEnabled = false
            infoStackView.isUserInteractionEnabled = false
        case .opened:
            view.frame.origin.y = opened
            smallPlayerView.alpha = 0
            parentRootTabBarController.tabBar.alpha = 0
            updateTopMargin(rootSelf: rootSelf)
            playerTitleLabelBig.isUserInteractionEnabled = true
            infoStackView.isUserInteractionEnabled = false
        case .partOpened:
            view.frame.origin.y = partOpened
            smallPlayerView.alpha = 1
            parentRootTabBarController.tabBar.alpha = 1
            updateTopMargin(rootSelf: rootSelf, 0, withBase: false)
            playerTitleLabelBig.isUserInteractionEnabled = false
            infoStackView.isUserInteractionEnabled = true
        }
        nowShowType = type
        if needExtraPart {
            finalExtraPart(showType: type)
        }
    }
    
    func startExtraPart(showType: ShowType) {
        switch showType {
        case .partOpened:
            view.isHidden = false
        case .closed:
            if #available(iOS 11.0, *) {
                setBottomAdditionalSafeAreaInsetForControllers(0)
            }
        default: break
        }
    }
    
    func finalExtraPart(showType: ShowType) {
        switch showType {
        case .partOpened:
            if #available(iOS 11.0, *) {
                let additionalSafeArea = parentRootTabBarController.tabBar.frame.height + smallPlayerView.frame.height
                setBottomAdditionalSafeAreaInsetForControllers(additionalSafeArea)
            }
        case .closed:
            clearPlayer()
            view.isHidden = true
        default: break
        }
    }
    
    @available(iOS 11.0, *)
    func setBottomAdditionalSafeAreaInsetForControllers(_ bottomEdgeSize: CGFloat) {
        guard let controllers = parentRootTabBarController.viewControllers else { return }
        for controller in controllers {
            controller.additionalSafeAreaInsets.bottom = bottomEdgeSize
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateMargins(rootSelf: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.parentRootTabBarController.view.setNeedsLayout()
            self.parentRootTabBarController.view.layoutIfNeeded()
            self.updateMargins(rootSelf: true)
        })
        super.viewWillTransition(to: size, with: coordinator)
    }

    func updateMargins(rootSelf: Bool = false) {
        if marginsUpdating { return }
        marginsUpdating = true
        let tabBarHeight: CGFloat = parentRootTabBarController.tabBar.frame.height
        closed = (view.superview ?? view).frame.height - tabBarHeight
        partOpened = closed - smallPlayerView.frame.height
        opened = view.superview?.frame.origin.y ?? 0
        setPlayerShow(type: nowShowType, rootSelf: rootSelf)
        marginsUpdating = false
    }
    
    func setTheme() {
        view.theme_backgroundColor = UIColor.Theme.third.picker
        smallPlayerView.theme_backgroundColor = UIColor.Theme.second.picker
        progressBar.theme_tintColor = UIColor.Theme.third.picker
        imageViewBig.theme_backgroundColor = UIColor.Theme.second.picker
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
    
    func updateAfterAnimation(block: @escaping (UIViewControllerTransitionCoordinatorContext?) -> Void) {
        if let transitionCoordinator = transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: nil, completion: block)
        } else { block(nil) }
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
    
    func reloadTableData() {
        tracksTableModule.tableView.reloadData()
    }
    
    func setZeroTableOffset() {
        tracksTableModule.tableView.setContentOffset(.zero, animated: false)
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
    
    func openFullPlayer(completion: @escaping () -> Void = {}) {
        let player = self
        let parent = player.parentRootTabBarController!
        guard let playerSnapshot = player.view.snapshotView(afterScreenUpdates: true),
              let tabBarSnapshot = parent.tabBar.snapshotView(afterScreenUpdates: true)
            else { return }
        playerSnapshot.frame = player.view.frame
        tabBarSnapshot.frame = parent.tabBar.frame
        parent.view.addSubview(playerSnapshot)
        parent.view.addSubview(tabBarSnapshot)
        view.removeFromSuperview()
        parent.present(player, animated: true) {
            playerSnapshot.removeFromSuperview()
            tabBarSnapshot.removeFromSuperview()
            if parent.presentedViewController != self {
                player.setInParent(initi: false)
            }
            completion()
        }
    }
    
    func closeFullPlayer(completion: @escaping () -> Void = {}) {
        let player = self
        let parent = player.parentRootTabBarController!
        dismiss(animated: true) {
            if parent.presentedViewController != self {
                player.setInParent(initi: false)
                completion()
            }
        }
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
    
    @IBAction func mixButtonClicked(_ sender: Any) {
        presenter.mixButtonClick()
    }
    
    @IBAction func playlistButtonClicked(_ sender: Any) {
        let alpha = tracksTableModule.view.alpha == 0
        playlistButtonBig.setImage(alpha ? #imageLiteral(resourceName: "icon_187") : #imageLiteral(resourceName: "icon_065"), for: .normal)
        turnPlaylist(alpha, duration: 0.2)
    }
    
}

extension SmallPlayerViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SmallPlayerAnimationController(self, forPresent: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SmallPlayerAnimationController(self, forPresent: false)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard interactionControllerDismiss?.interactionInProgress ?? false else { return nil }
        return interactionControllerDismiss
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard interactionControllerPresent?.interactionInProgress ?? false else { return nil }
        return interactionControllerPresent
    }
    
}
