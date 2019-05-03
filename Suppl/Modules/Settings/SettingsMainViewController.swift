import Foundation
import UIKit

class SettingsMainViewController: UIViewController, ControllerInfoProtocol {
    
    private struct Constants {
        static let settingsStoryboardName = "SettingsStoryboard"
    }
    
    public let name = "settingsTitle".localizeKey
    public let image = #imageLiteral(resourceName: "icon_186")
    
    @IBOutlet weak var titleLabel: UILabel!
    
    static func initial() -> SettingsMainViewController {
        let storyboard = UIStoryboard(name: Constants.settingsStoryboardName, bundle: nil)
        return storyboard.instantiateInitialViewController() as! SettingsMainViewController
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = name
        titleLabel.text = name
    }
}
