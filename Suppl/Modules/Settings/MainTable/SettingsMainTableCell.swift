import Foundation
import UIKit

class SettingsMainTableCell: UITableViewCell {
    
    static let identifier = String(describing: SettingsMainTableCell.self)
    
    @IBOutlet weak var sImage: UIImageView!
    @IBOutlet weak var sTitle: UILabel!
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        setTheme()
    }
    
    func setTheme() {
        sImage.theme_tintColor = "secondColor"
    }
    
    public func setImage(_ image: UIImage?) {
        sImage.image = image?.withRenderingMode(.alwaysTemplate)
    }
    
    public func setTitle(_ title: String?) {
        sTitle.text = title
    }
    
    public func fromConfig(_ config: SettingsMainTableViewController.CellConfig) {
        setTitle(config.title)
        setImage(config.image)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sImage.image = nil
        sTitle.text = nil
    }
    
}
