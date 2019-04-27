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
        
        let NC = NotificationCenter.default
        if #available(iOS 11.0, *) {
            NC.addObserver(self, selector: #selector(keyboardFrameWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        }
        NC.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NC.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        view.clipsToBounds = true
        smallPlayer = SmallPlayerRouter.setup(parentRootTabBarController: self)
        
        TracklistManager.shared.update()
    }

    func setTheme() {
        tabBar.theme_barTintColor = ThemeColor.second.picker
        tabBar.theme_tintColor = [AppStaticData.Consts.widthColorHash]
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
        controller.navigationController?.tabBarItem = UITabBarItem(
            title: controllerInfo.name,
            image: controllerInfo.image,
            tag: tag
        )
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
        guard gesture.state == UIGestureRecognizer.State.ended else { return }
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard tapGestureRecognizer == nil else { return }
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAndHideKeyboard(_:)))
        view.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let tapGestureRecognizer = tapGestureRecognizer else { return }
        view.removeGestureRecognizer(tapGestureRecognizer)
        self.tapGestureRecognizer = nil
    }
    
    @available(iOS 11.0, *)
    @objc private func keyboardFrameWillChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let safeAreaFrame = view.safeAreaLayoutGuide.layoutFrame.insetBy(dx: 0, dy: -additionalSafeAreaInsets.bottom)
        let intersection = safeAreaFrame.intersection(keyboardFrameInView)
        
        let animationDuration: TimeInterval = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: animationCurve, animations: {
            self.additionalSafeAreaInsets.bottom = intersection.height - self.tabBar.frame.height
            self.view.layoutIfNeeded()
        })
    }

}
