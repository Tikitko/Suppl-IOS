import UIKit

class TrackTableCell: UITableViewCell {
    
    static let identifier = String(describing: TrackTableCell.self)
    
    private(set) var baseImage = true
    
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackPerformer: UILabel!
    @IBOutlet weak var trackDuration: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        baseImage = true
        trackTitle.text = nil
        trackPerformer.text = nil
        trackDuration.text = nil
        trackImage.image = #imageLiteral(resourceName: "cd")
    }
    
    public func configure(title: String? = nil, performer: String? = nil, duration: Int? = nil) -> Void {
        loadImageType()
        if let title = title {
            trackTitle.text = title
        }
        if let performer = performer {
            trackPerformer.text = performer
        }
        if let duration = duration {
            trackDuration.text = TrackTime(sec: duration).formatted
        }
    }
    
    public func setImage(image: UIImage) {
        loadImageType()
        baseImage = false
        trackImage.image = image
    }
    
    public func setImage(imageData: NSData) {
        guard let image = UIImage(data: imageData as Data) else { return }
        setImage(image: image)
    }
    
    private func loadImageType() {
        if SettingsManager.s.roundIcons! {
            trackImage.layer.cornerRadius = trackImage.frame.size.width / 2
            trackImage.clipsToBounds = true
            return
        }
        trackImage.layer.cornerRadius = 0
        trackImage.clipsToBounds = false
    }

}
