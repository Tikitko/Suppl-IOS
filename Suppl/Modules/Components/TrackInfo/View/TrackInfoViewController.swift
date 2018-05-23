import UIKit

class TrackInfoViewController: UIViewController, TrackInfoViewControllerProtocol {

    var presenter: TrackInfoPresenterProtocol!

    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackPerformer: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    
    var baseImage = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        trackImage.clipsToBounds = true
        presenter.setListeners()
    }

    func setInfo(title: String, performer: String, durationString: String) {
        trackTitle.text = title
        trackPerformer.text = performer
        trackDuration.text = durationString
    }
    
    func setImage(image: UIImage) {
        guard baseImage else { return }
        baseImage = false
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
    }
    
}
