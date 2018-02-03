import UIKit

class TrackTableCell: UITableViewCell {
    
    static let identifier = String(describing: TrackTableCell.self)
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackPerformer: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackTitle.text = nil
        trackPerformer.text = nil
        trackImage.image = UIImage(named: "cd.png")
    }
    
    public func configure(title: String? = nil, performer: String? = nil, image: UIImage? = nil) -> Void {
        if let title = title {
            trackTitle.text = title
        }
        if let performer = performer {
            trackPerformer.text = performer
        }
        if let image = image {
            trackImage.image = image
        }
    }

}
