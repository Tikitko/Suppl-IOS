import UIKit

class TrackInfoViewController: UIViewController, TrackInfoViewControllerProtocol {

    var presenter: TrackInfoPresenterProtocolView!

    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackPerformer: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var percentagesLabel: UILabel!
    @IBOutlet weak var loadProgressBar: UIProgressView!
    @IBOutlet weak var loadImage: UIImageView!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var blurView: UIView!
    var loadCircle: CircleLoad!
    
    var baseImage = true
    let allowDownloadButton = UIApplication.topViewController() is TracklistViewController
    
    enum LoadButtonType {
        case download
        case сancel
        case remove
        var image: UIImage {
            switch self {
            case .download: return #imageLiteral(resourceName: "icon_206")
            case .remove: return #imageLiteral(resourceName: "icon_228")
            case .сancel: return #imageLiteral(resourceName: "icon_182")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        loadCircle = CircleLoad(frame: blurView.bounds, radiusOffset: 10, lineWidth: 5, color: .white)
        loadCircle.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.addSubview(loadCircle)
        loadProgressBar.isHidden = true
        
        blurView.layer.cornerRadius = 5
        blurView.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        trackImage.clipsToBounds = true
        blurView.clipsToBounds = true
        resetInfo()
        presenter.setListeners()
        presenter.requestOfflineMode()
    }
    
    func setTheme() {
        loadButton.theme_tintColor = "secondColor"
    }

    func setInfo(title: String, performer: String, durationString: String) {
        trackTitle.text = title
        trackPerformer.text = performer
        trackDuration.text = durationString
    }
    
    func setLoadButtonType(_ type: LoadButtonType) {
        loadButton.setImage(type.image.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    func turnLoadButton(_ isOn: Bool) {
        if isOn, !allowDownloadButton { return }
        loadButton.isHidden = !isOn
        loadButton.isEnabled = !presenter.isOffline && isOn
    }
    
    func enableLoadButton(_ isOn: Bool) {
        loadButton.isEnabled = isOn
    }
    
    func turnLoadImage(_ isOn: Bool) {
        loadImage.isHidden = !isOn
    }
    
    func turnLoad(_ isOn: Bool) {
        if !isOn {
            setLoadPercentages(0)
        }
        //loadProgressBar.isHidden = !isOn
        percentagesLabel.isHidden = !isOn
        blurView.isHidden = !isOn
    }
    
    func setLoadPercentages(_ percentages: Int) {
        //loadProgressBar.progress = Float(percentages) / 100
        percentagesLabel.text = "\(percentages)%"
        loadCircle.currentAngle = Float((percentages * 360) / 100)
    }
    
    func setImage(_ image: UIImage) {
        guard baseImage else { return }
        baseImage = false
        trackImage.image = image
        /*UIView.transition(with: trackImage, duration: 0.2, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.trackImage.image = image
        }, completion: nil)*/
    }
    
    func setRoundImage(_ value: Bool) {
        let cornerRadius = value ? trackImage.frame.width / 2 : 5
        trackImage.layer.cornerRadius = cornerRadius
        blurView.layer.cornerRadius = cornerRadius
    }
    
    func setSelected(_ value: Bool, instantly: Bool = false) {
        let result = value ? UIColor(white: 0.96, alpha: 1.0) : nil
        if instantly {
            view.backgroundColor = result
        } else {
            setBackgroundColorWithAnimation(result)
        }
    }

    func setBackgroundColorWithAnimation(_ color: UIColor?) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.backgroundColor = color
        }
    }
    
    func resetInfo() {
        baseImage = true
        trackTitle.text = nil
        trackPerformer.text = nil
        trackDuration.text = nil
        trackImage.image = #imageLiteral(resourceName: "cd")
        presenter.clearTrack()
        view.backgroundColor = nil
        turnLoadImage(false)
        turnLoad(false)
        turnLoadButton(false)
        loadCircle.currentAngle = 0
    }
    
    @IBAction func loadButtonClick(_ sender: Any) {
        presenter.loadButtonClick()
    }
    
}
