import Foundation
import UIKit

class RootTabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let mainTab = getSettingTab(controller: MainViewController())
        let tracklistTab = getSettingTab(controller: TracklistViewController())
        let settingsTab = getSettingTab(controller: SettingsViewController())
        viewControllers = [mainTab, tracklistTab, settingsTab]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func getSettingTab(controller: UIViewController) -> UIViewController {
        let controllerTab = BaseNavigationController(rootViewController: controller)
        setTabItem(controller: controller, tag: (viewControllers?.count ?? 0) + 1)
        return controllerTab
    }
    
    private func setTabItem(controller: UIViewController, tag: Int) {
        guard let controllerInfo = controller as? ControllerInfoProtocol else { return }
        controller.navigationController?.tabBarItem = UITabBarItem(title: controllerInfo.name, image: UIImage(named: controllerInfo.imageName), tag: tag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
