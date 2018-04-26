import Foundation
import UIKit

class SettingsMainViewController: UIViewController, ControllerInfoProtocol {
    
    public let name: String = LocalesManager.s.get(.settingsTitle)
    public let imageName = "gear-7.png"
    
    static func initial() -> SettingsMainViewController {
        let storyboard = UIStoryboard(name: "SettingsStoryboard", bundle: nil)
        return storyboard.instantiateInitialViewController() as! SettingsMainViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = name
    }
}
