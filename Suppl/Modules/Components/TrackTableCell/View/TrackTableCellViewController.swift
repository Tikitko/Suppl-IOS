import UIKit

class TrackTableCellViewController: UITableViewCell, TrackTableCellViewControllerProtocol {
    
    static let identifier = String(describing: TrackTableCellViewController.self)

    var presenter: TrackTableCellPresenterProtocol!
    
    var view: UIView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackPerformer: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    
    var baseImage = true
    
    convenience init() {
        self.init(style: .default, reuseIdentifier: TrackTableCellViewController.identifier)
        xibSetup()
        layer.cornerRadius = 5
        clipsToBounds = true
        trackImage.clipsToBounds = true
    }
    
    private override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func xibSetup() {
        view = UINib(nibName: TrackTableCellViewController.identifier, bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view);
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
            backgroundColor = result
        } else {
            setBackgroundColorWithAnimation(result)
        }
    }

    func setBackgroundColorWithAnimation(_ color: UIColor?) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.backgroundColor = color
        }, completion: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        presenter.setListeners()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        baseImage = true
        trackTitle.text = nil
        trackPerformer.text = nil
        trackDuration.text = nil
        trackImage.image = #imageLiteral(resourceName: "cd")
        presenter.clearTrack()
        backgroundColor = nil
    }
    
}
