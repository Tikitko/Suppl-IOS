import Foundation
import UIKit

class RootTabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setTab(controller: UIViewController, tag: Int) {
        guard let controllerInfo = controller as? ControllerInfoProtocol else { return }
        controller.navigationController?.tabBarItem = UITabBarItem(title: controllerInfo.name, image: controllerInfo.image, tag: tag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainViewController = MainViewController()
        let mainTab = RootNavigationController(rootViewController: mainViewController)
        setTab(controller: mainViewController, tag: 1)
        
        let tracklistViewController = TracklistViewController()
        let tracklistTab = RootNavigationController(rootViewController: tracklistViewController)
        setTab(controller: tracklistViewController, tag: 2)
        
        let settingsViewController = SettingsViewController()
        let settingsTab = RootNavigationController(rootViewController: settingsViewController)
        setTab(controller: settingsViewController, tag: 3)
        
        viewControllers = [mainTab, tracklistTab, settingsTab]
    }
}
