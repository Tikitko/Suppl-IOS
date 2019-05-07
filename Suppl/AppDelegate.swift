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
import SwiftTheme
import Toast_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        initToastManager()
        initThemeManager()
        initAuthManager()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return processDeepLink(url)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        stopAuthCheck()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        startAuthCheck()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        stopAuthCheck()
    }    

}

private extension AppDelegate {
    
    func initToastManager() {
        ToastManager.shared.isQueueEnabled = true
    }
    
    func initThemeManager() {
        func setTheme(_ themeId: Int) {
            ThemeManager.setTheme(plistName: type(of: self).themesList[themeId], path: .mainBundle)
        }
        let themeSetting = SettingsManager.shared.theme
        setTheme(themeSetting.value)
        themeSetting.addObserver(queue: .main) { setTheme($0.value()!) }
    }
    
    func initAuthManager() {
        AuthManager.shared.setAuthWindow()
    }
    
    func processDeepLink(_ url: URL) -> Bool {
        switch url.host {
        case "resetKey":
            if let authVC = UIApplication.shared.keyWindow?.rootViewController as? AuthViewController {
                authVC.resetKey = url.lastPathComponent
                authVC.viewDidAppear(false)
                return true
            }
            fallthrough
        default:
            return false
        }
    }
    
    func startAuthCheck() {
        if UIApplication.shared.keyWindow?.rootViewController is AuthViewController { return }
        _ = AuthManager.shared.startAuthCheck(startNow: true)
    }
    
    func stopAuthCheck() {
        _ = AuthManager.shared.stopAuthCheck()
    }
    
}

extension AppDelegate {
    
    public static let enableBackendFixes = true
    public static let oldPlayerAnimation = false
    
    public static let baseSearchQueriesList = [
        "Pink Floyd",
        "Led Zeppelin",
        "Rolling Stones",
        "Queen",
        "Nirvana",
        "The Beatles",
        "Metallica",
        "Bon Jovi",
        "AC/DC",
        "Red Hot Chili Peppers"
    ]
    
    public static let themesList = [
        "Purple",
        "Blue",
        "Black"
    ]
    
    public static let locales = [
        "en",
        "ru"
    ]
    
}
