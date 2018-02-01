import Foundation
import UIKit

class AuthManager {
    
    private static var timer: Timer? = nil
    
    private static func authCheck(timerIn: Timer) -> Void {
        authCheckRequest()
    }
    
    private static func authCheckRequest() {
        guard let ikey = UserDefaultsManager.identifierKey, let akey = UserDefaultsManager.accessKey else { return }
        APIManager.userGet(ikey: ikey, akey: akey) { error, data in
            guard let _ = error else { return }
            let _ = self.setAuthWindow()
        }
    }
    
    public static func setAuthWindow(setInWindow: Bool = true) -> UIViewController? {
        let authView = AuthViewController()
        let _ = stopAuthCheck()
        if setInWindow, let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = authView
            return nil
        }
        return authView
    }
    
    public static func startAuthCheck(startNow: Bool = false, voidTopCheck: Bool = false) -> Bool {
        if !voidTopCheck, let topController = UIApplication.topViewController(), let _ = topController as? AuthViewController {
            return false;
        }
        if startNow {
            authCheckRequest()
        }
        guard let _ = timer else {
            timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: authCheck)
            return true
        }
        return false
    }
    
    public static func stopAuthCheck() -> Bool {
        if let _ = timer {
            timer?.invalidate()
            timer = nil
            return true
        }
        return false
    }
    
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
