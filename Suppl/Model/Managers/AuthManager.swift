import Foundation

class AuthManager {
    
    private static var timer: Timer?
    
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
    
    public static func setAuthWindow(noAuth: Bool = false) {
        AuthRouter.setSelf()
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
    
    public static func getAuthKeys(setFailAuth: Bool = true) -> (ikey:Int, akey:Int)? {
        guard let ikey = UserDefaultsManager.identifierKey, let akey = UserDefaultsManager.accessKey else {
            if setFailAuth {
                setAuthWindow()
            }
            return nil
        }
        return (ikey, akey)
    }
    
    public static func authorization(ikey: Int?, akey: Int?, callback: @escaping (String?) -> Void) {
        let keys = getAuthKeys()
        guard let ikey = ikey ?? keys?.ikey, let akey = akey ?? keys?.akey else { return }
        APIManager.userGet(ikey: ikey, akey: akey) { error, data in
            if let error = error {
                callback(APIManager.errorHandler(error))
                return
            }
            callback(nil)
        }
    }
    
    public static func registration(callback: @escaping (String?) -> Void) {
        APIManager.userRegister() { error, data in
            if let error = error {
                callback(APIManager.errorHandler(error))
                return
            }
            UserDefaultsManager.identifierKey = data!.identifierKey
            UserDefaultsManager.accessKey = data!.accessKey
            callback(nil)
        }
    }
    
}
