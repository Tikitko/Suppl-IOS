import Foundation
import UIKit
import SwiftTheme

class RootTabBarController: UITabBarController {
    
    var tapGestureRecognizer: UITapGestureRecognizer?
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        // NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setTheme() {
        //tabBar.barTintColor = AppData.getTheme(SettingsManager.theme).secondColor
        //tabBar.tintColor = UIColor.white
        //tabBar.unselectedItemTintColor = UIColor.lightGray
        tabBar.theme_barTintColor = "secondColor"
        tabBar.theme_tintColor = ["#FFF"]
        tabBar.unselectedItemTintColor = UIColor.lightGray
    }
    
    @objc func tapAndHideKeyboard(_ gesture: UITapGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.ended {
            view.endEditing(false)
        }
    }
    
    @objc func keyboardWillShow() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAndHideKeyboard(_:)))
        view.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    @objc func keyboardWillHide() {
        guard let tapGestureRecognizer = tapGestureRecognizer else { return }
        view.removeGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func keyboardFrameWillChange(_ notification: Notification) {
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
