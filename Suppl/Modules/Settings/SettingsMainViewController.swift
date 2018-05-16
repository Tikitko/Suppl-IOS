import Foundation
import UIKit

class SettingsMainViewController: UIViewController, ControllerInfoProtocol {
    
    public let name: String = LocalesManager.s.get(.settingsTitle)
    public let imageName: String = "gear-7.png"
    
    static func initial() -> SettingsMainViewController {
        let storyboard = UIStoryboard(name: "SettingsStoryboard", bundle: nil)
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
    }
}