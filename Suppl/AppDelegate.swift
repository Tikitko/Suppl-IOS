//
//    ╭━━━╮        ╭╮
//    ┃╭━╮┃        ┃┃
//    ┃╰━━┳╮╭┳━━┳━━┫┃
//    ╰━━╮┃┃┃┃╭╮┃╭╮┃┃
//    ┃╰━╯┃╰╯┃╰╯┃╰╯┃╰╮
//    ╰━━━┻━━┫╭━┫╭━┻━╯
//           ┃┃ ┃┃
//           ╰╯ ╰╯
//
//  Copyright © 2018 Mikita Bykau. All rights reserved.
//

import Foundation
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        ToastManager.shared.isQueueEnabled = true
        SettingsManager.s.setTheme()
        AuthManager.s.setAuthWindow()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        switch url.host {
        case "resetKey":
            if let authVC = UIApplication.topViewController() as? AuthViewController {
                authVC.resetKeyForUse = url.lastPathComponent
                authVC.viewDidAppear(false)
            }
            return true
        default: return false
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        let _ = AuthManager.s.stopAuthCheck()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if UIApplication.topViewController() is AuthViewController { return }
        let _ = AuthManager.s.startAuthCheck(startNow: true)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        let _ = AuthManager.s.stopAuthCheck()
    }    

}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let selectedInTabBarController = (controller as? UITabBarController)?.selectedViewController {
            return topViewController(controller: selectedInTabBarController)
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
