import Foundation
import UIKit

class RootTabBarController: UITabBarController {
    
    public static let baseColor = UIColor(red: 0.58, green: 0.13, blue: 0.57, alpha: 1.0)
    public static let elementsColor = UIColor(red: 0.59, green: 0.17, blue: 0.63, alpha: 1.0)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        tabBar.barTintColor = RootTabBarController.elementsColor
        tabBar.tintColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor.lightGray
        
        let mainTab = getSettedTab(controller: MainViewController())
        let tracklistTab = getSettedTab(controller: TracklistViewController())
        let settingsTab = getSettedTab(controller: SettingsMainViewController.storyboardInstance()!)
        viewControllers = [mainTab, tracklistTab, settingsTab]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAvoidingKeyboard()
    }
    
    func startAvoidingKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(_onKeyboardFrameWillChangeNotificationReceived(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    func stopAvoidingKeyboard() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc private func _onKeyboardFrameWillChangeNotificationReceived(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: -additionalSafeAreaInsets.bottom)
        let intersection = safeAreaFrame.intersection(keyboardFrameInView)
        
        let animationDuration: TimeInterval = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
        let animationCurve = UIViewAnimationOptions(rawValue: animationCurveRaw)
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve, animations: {
            self.additionalSafeAreaInsets.bottom = intersection.height - self.tabBar.frame.height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func getSettedTab(controller: UIViewController) -> UIViewController {
        let controllerTab = BaseNavigationController(rootViewController: controller)
        setTabItem(controller: controller, tag: (viewControllers?.count ?? 0) + 1)
        return controllerTab
    }
    
    private func setTabItem(controller: UIViewController, tag: Int) {
        guard let controllerInfo = controller as? ControllerInfoProtocol else { return }
        controller.navigationController?.tabBarItem = UITabBarItem(title: controllerInfo.name, image: UIImage(named: controllerInfo.imageName), tag: tag)
        
        controller.navigationController?.navigationBar.barTintColor = RootTabBarController.elementsColor
        controller.navigationController?.navigationBar.tintColor = UIColor.white
        controller.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }

}
