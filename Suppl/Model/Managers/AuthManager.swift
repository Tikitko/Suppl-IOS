import Foundation

class AuthManager {
    
    private static var timer: Timer? = nil
    
    private static func authCheck(timerIn: Timer) -> Void {
        authCheckRequest()
    }
    
    private static func authCheckRequest() {
        guard let (ikey, akey) = getAuthKeys() else { return }
        APIManager.userGet(ikey: ikey, akey: akey) { error, data in
            guard let _ = error else { return }
            let _ = self.setAuthWindow()
        }
    }
    
    public static func setAuthWindow(noAuth: Bool = false) -> Void {
        NotificationCenter.default.post(name: .NeedAuthWindow, object: nil, userInfo: ["noAuth": noAuth])
    }
    
    public static func startAuthCheck(startNow: Bool = false) -> Bool {
        if startNow {
            authCheckRequest()
        }
        guard let _ = timer else {
            timer = Timer.scheduledTimer(withTimeInterval: 60 * 1, repeats: true, block: authCheck)
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
    
    public static func getAuthKeys() -> (ikey:Int, akey:Int)? {
        guard let ikey = UserDefaultsManager.identifierKey, let akey = UserDefaultsManager.accessKey else {
            setAuthWindow()
            return nil
        }
        return (ikey, akey)
    }
    
}

extension Notification.Name {
    static let NeedAuthWindow = Notification.Name("NeedAuthWindow")
}
