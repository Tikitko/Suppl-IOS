import Foundation
import UIKit
import SwiftTheme

class RootTabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
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
        setTheme()
        startAvoidingKeyboard()
        /*
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAndHideKeyboard(_:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panAndHideKeyboard(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.addGestureRecognizer(panGestureRecognizer)
         */
    }
    
    func setTheme() {
        //tabBar.barTintColor = AppData.getTheme(SettingsManager.theme).secondColor
        //tabBar.tintColor = UIColor.white
        //tabBar.unselectedItemTintColor = UIColor.lightGray
        tabBar.theme_barTintColor = "secondColor"
        tabBar.theme_tintColor = ["#FFF"]
        tabBar.unselectedItemTintColor = UIColor.lightGray
    }
    
    private func startAvoidingKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(_onKeyboardFrameWillChangeNotificationReceived(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    private func stopAvoidingKeyboard() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func tapAndHideKeyboard(_ gesture: UITapGestureRecognizer) {
        print(123)
        if(gesture.state == UIGestureRecognizerState.ended) {
            view.endEditing(true)
        }
    }
    
    @objc func panAndHideKeyboard(_ gesture: UIPanGestureRecognizer) {
        print(321)
        if(gesture.state == UIGestureRecognizerState.ended) {
            view.endEditing(true)
        }
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
    }

}
