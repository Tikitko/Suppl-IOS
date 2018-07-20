import Foundation
import UIKit

final class RootTabBarController: UITabBarController {
    
    var tapGestureRecognizer: UITapGestureRecognizer?
    
    private(set) var smallPlayer: UIViewController!
    private var smallPlayerConstraints: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        tabBar.isTranslucent = false
        
        var controllers: [UIViewController] = [TracklistRouter.setup(), SettingsMainViewController.initial()]
        controllers[0].loadViewIfNeeded()
        if !OfflineModeManager.shared.offlineMode {
            controllers.insert(MainRouter.setup(), at: 0)
        }
        setupControllers(controllers)
        
        if #available(iOS 11.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillChange), name: .UIKeyboardWillChangeFrame, object: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)

        view.clipsToBounds = true
        smallPlayer = SmallPlayerRouter.setup(parentRootTabBarController: self)
        
        TracklistManager.shared.update()
    }

    func setTheme() {
        tabBar.theme_barTintColor = "secondColor"
        tabBar.theme_tintColor = ["#FFF"]
        tabBar.unselectedItemTintColor = .lightGray
    }
    
    private func setupControllers(_ controllers: [UIViewController]) {
        for controller in controllers {
            setupController(controller)
        }
    }
    
    private func setupController(_ controller: UIViewController) {
        guard let controllerInfo = controller as? ControllerInfoProtocol else { return }
        let controllerTab = BaseNavigationController(rootViewController: controller)
        let tag = (viewControllers?.count ?? 0) + 1
        controller.navigationController?.tabBarItem = UITabBarItem(title: controllerInfo.name, image: controllerInfo.image, tag: tag)
        if viewControllers == nil {
            viewControllers = [controllerTab]
        } else {
            viewControllers?.append(controllerTab)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        smallPlayer.viewWillTransition(to: size, with: coordinator)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    @objc func tapAndHideKeyboard(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == UIGestureRecognizerState.ended else { return }
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow() {
        guard tapGestureRecognizer == nil else { return }
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAndHideKeyboard(_:)))
        view.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    @objc func keyboardWillHide() {
        guard let tapGestureRecognizer = tapGestureRecognizer else { return }
        view.removeGestureRecognizer(tapGestureRecognizer)
        self.tapGestureRecognizer = nil
    }
    
    @available(iOS 11.0, *)
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

}
