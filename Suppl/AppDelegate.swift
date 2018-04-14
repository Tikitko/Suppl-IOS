//
//  AppDelegate.swift
//  Suppl
//
//  Created by Mikita Bykau on 1/26/18.
//  Copyright © 2018 Mikita Bykau. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SettingsManager.initialize()
        self.window = AuthRouter.setupInWindow()
        NotificationCenter.default.addObserver(self, selector: #selector(authWindowSet(notification:)), name: .NeedAuthWindow, object: nil)

        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try? AVAudioSession.sharedInstance().setActive(true)
        application.beginReceivingRemoteControlEvents()
        
        return true
    }

    @objc private func authWindowSet(notification: NSNotification) {
        let _ = AuthManager.stopAuthCheck()
        if let topController = UIApplication.topViewController() {
            topController.present(AuthRouter.setup(noAuth: notification.userInfo?["noAuth"] as? Bool ?? false), animated: true)
        }
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

