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
        ThemeMainManager.shared.set()
        AuthManager.shared.setAuthWindow()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        switch url.host {
        case AppStaticData.Consts.deeplinkResetKey:
            if let authVC = UIApplication.shared.keyWindow?.rootViewController as? AuthViewController {
                authVC.resetKey = url.lastPathComponent
                authVC.viewDidAppear(false)
            }
            return true
        default: return false
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        let _ = AuthManager.shared.stopAuthCheck()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if UIApplication.shared.keyWindow?.rootViewController is AuthViewController { return }
        let _ = AuthManager.shared.startAuthCheck(startNow: true)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        let _ = AuthManager.shared.stopAuthCheck()
    }    

}
