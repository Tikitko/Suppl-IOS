//
//  AppDelegate.swift
//  Suppl
//
//  Created by Mikita Bykau on 1/26/18.
//  Copyright © 2018 Mikita Bykau. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = AuthViewController()
        window.makeKeyAndVisible()
        self.window = window
        NotificationCenter.default.addObserver(self, selector: #selector(authWindowSet(notification:)), name: .NeedAuthWindow, object: nil)
        return true
    }
    
    @objc private func authWindowSet(notification: NSNotification) {
        let authView = AuthViewController()
        let _ = AuthManager.stopAuthCheck()
        if let topController = UIApplication.topViewController() {
            topController.present(authView, animated: true)
        }
        /*
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = authView
        }
         */
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        let _ = AuthManager.stopAuthCheck()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if let topController = UIApplication.topViewController(), let _ = topController as? AuthViewController { return }
        let _ = AuthManager.startAuthCheck(startNow: true)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        let _ = AuthManager.stopAuthCheck()
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

