import Foundation

final class AuthManager {
    
    static public let s = AuthManager()
    private init() {}
    
    private var timer: Timer?
    
    private func authCheck(timerIn: Timer) -> Void {
        authCheckRequest()
    }
    
    private func authCheckRequest() {
        guard let keys = getAuthKeys() else { return }
        APIManager.s.userGet(keys: keys) { error, data in
            guard let _ = error else { return }
            let _ = self.setAuthWindow()
        }
    }
    
    public func setAuthWindow(noAuth: Bool = false) {
        let _ = stopAuthCheck()
        AuthRouter.setSelf(noAuth: noAuth)
    }
    
    public func startAuthCheck(startNow: Bool = false) -> Bool {
        if startNow {
            authCheckRequest()
        }
        guard let _ = timer else {
            timer = Timer.scheduledTimer(withTimeInterval: 60 * 1, repeats: true, block: authCheck)
            return true
        }
        return false
    }
    
    public func stopAuthCheck() -> Bool {
        if let _ = timer {
            timer?.invalidate()
            timer = nil
            return true
        }
        return false
    }
    
    public func getAuthKeys(setFailAuth: Bool = true) -> KeysPair? {
        guard let ikey = UserDefaultsManager.s.identifierKey, let akey = UserDefaultsManager.s.accessKey else {
            if setFailAuth {
                setAuthWindow()
            }
            return nil
        }
        return KeysPair(ikey, akey)
    }
    
    public func authorization(keys: KeysPair?, callback: @escaping (String?) -> Void) {
        let keysFromDefaults = getAuthKeys()
        guard let keys = keys ?? keysFromDefaults else { return }
        APIManager.s.userGet(keys: keys) { error, data in
            if let error = error {
                callback(error.getAPIErrorString())
                return
            }
            callback(nil)
        }
    }
    
    public func registration(callback: @escaping (String?) -> Void) {
        APIManager.s.userRegister() { error, data in
            if let error = error {
                callback(error.getAPIErrorString())
                return
            }
            UserDefaultsManager.s.identifierKey = data!.identifierKey
            UserDefaultsManager.s.accessKey = data!.accessKey
            callback(nil)
        }
    }
    
}

