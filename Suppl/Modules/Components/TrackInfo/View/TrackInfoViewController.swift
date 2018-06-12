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
    
    var baseImage = true
    let allowDownloadButton = (UIApplication.topViewController() as? MainViewController) == nil
    
    enum LoadButtonType {
        case download
        case сancel
        case remove
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        trackImage.clipsToBounds = true
        resetInfo()
        presenter.setListeners()
        presenter.requestOfflineMode()
    }

    func setInfo(title: String, performer: String, durationString: String) {
        trackTitle.text = title
        trackPerformer.text = performer
        trackDuration.text = durationString
    }
    
    func setLoadButtonType(_ type: LoadButtonType) {
        let image: UIImage
        switch type {
        case .download: image = #imageLiteral(resourceName: "cloud-download-7")
        case .remove: image = #imageLiteral(resourceName: "bin-7")
        case .сancel: image = #imageLiteral(resourceName: "circle-x-7")
        }
        loadButton.setImage(image, for: .normal)
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
        loadProgressBar.isHidden = !isOn
        percentagesLabel.isHidden = !isOn
    }
    
    func setLoadPercentages(_ percentages: Int) {
        loadProgressBar.progress = Float(percentages) / 100
        percentagesLabel.text = "\(percentages)%"
    }
    
    func setImage(_ image: UIImage) {
        guard baseImage else { return }
        baseImage = false
        
        //trackImage.image = image
        UIView.transition(with: trackImage, duration: 0.2, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.trackImage.image = image
        }, completion: nil)
    }
    
    func setRoundImage(_ value: Bool) {
        trackImage.layer.cornerRadius = value ? trackImage.frame.width / 2 : 5
    }
    
    func setSelected(_ value: Bool, instantly: Bool = false) {
        let result = value ? UIColor(hue: 0.7778, saturation: 0, brightness: 0.96, alpha: 1.0) : nil
        if instantly {
            view.backgroundColor = result
        } else {
            setBackgroundColorWithAnimation(result)
        }
    }

    func setBackgroundColorWithAnimation(_ color: UIColor?) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.backgroundColor = color
        }, completion: nil)
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
    }
    
    @IBAction func loadButtonClick(_ sender: Any) {
        presenter.loadButtonClick()
    }
    
}
