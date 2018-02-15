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
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = AuthViewController()
        window.makeKeyAndVisible()
        self.window = window
        NotificationCenter.default.addObserver(self, selector: #selector(authWindowSet(notification:)), name: .NeedAuthWindow, object: nil)

        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try? AVAudioSession.sharedInstance().setActive(true)
        application.beginReceivingRemoteControlEvents()
        
        getAndPrintAPIInfo()
        
        return true
    }
    
    private func getAndPrintAPIInfo() {
        
        // Example of usage objC language...
        
        CommonRequestC().request(APIRequest.API_URL, query: ["method": "info"], inMain: true) { data, response, error in
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let jsonCheck = json,
                let info = jsonCheck["data"] as? [String: String] else { return }
            
            print("""
                
                API Core Information:
                Title: \(info["title"] ?? "")
                Description: \(info["description"] ?? "")
                Author: \(info["author"] ?? "")
                Version: \(info["version"] ?? "")
                
            """)
        }
    }
    
    @objc private func authWindowSet(notification: NSNotification) {
        let authView = AuthViewController(noAuth: notification.userInfo?["noAuth"] as? Bool ?? false)
        let _ = AuthManager.stopAuthCheck()
        if let topController = UIApplication.topViewController() {
            topController.present(authView, animated: true)
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

