import Foundation
import UIKit

class AuthManager {
    
    private static var timer: Timer? = nil
    
    private static func authCheck(timerIn: Timer) -> Void {
        guard let ikey = UserDefaultsManager.identifierKey, let akey = UserDefaultsManager.accessKey else { return }
        APIManager.userGet(ikey: ikey, akey: akey) { error, data in
            print("ok")
            guard let error = error else { return }
            defer { self.timer = nil }
            self.timer?.invalidate()
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController = AuthViewController()
            }
        }
    }
    
    public static func startAuthCheck() {
        if let _ = timer {
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: authCheck)
    }
    
}
