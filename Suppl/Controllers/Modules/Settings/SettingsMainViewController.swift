import Foundation
import UIKit

class SettingsMainViewController: UIViewController, ControllerInfoProtocol {
    
    public let name = "Настройки"
    public let imageName = "gear-7.png"
    
    static func storyboardInstance() -> SettingsMainViewController? {
        let storyboard = UIStoryboard(name: "SettingsStoryboard", bundle: nil)
        return storyboard.instantiateInitialViewController() as? SettingsMainViewController
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.title = name
    }
}
