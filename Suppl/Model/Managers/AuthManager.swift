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
        APIManager.s.user.get(keys: keys) { error, data in
            guard let _ = error else { return }
            let _ = self.setAuthWindow()
        }
    }
    
    public func setAuthWindow(noAuth: Bool = false) {
        PlayerItemsManager.s.removeDownloadableItems()
        PlayerManager.s.clearPlayer()
        let _ = stopAuthCheck()
        AuthRouter.setSelf(noAuth: noAuth)
    }
    
    public func startAuthCheck(startNow: Bool = false) -> Bool {
        if OfflineModeManager.s.offlineMode { return false }
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
    
    public func authorization(keys: KeysPair? = nil, callback: @escaping (UserData?, NSError?) -> Void) {
        guard let keys = keys ?? getAuthKeys() else { return }
        APIManager.s.user.get(keys: keys) { error, data in
            callback(data, error)
        }
    }
    
    public func registration(callback: @escaping (UserSecretData?, NSError?) -> Void) {
        APIManager.s.user.register() { error, data in
            if let error = error {
                callback(nil, error)
                return
            }
            UserDefaultsManager.s.identifierKey = data!.identifierKey
            UserDefaultsManager.s.accessKey = data!.accessKey
            callback(data, nil)
        }
    }
    
    public func reset(resetKey: String, callback: @escaping (UserSecretData?, NSError?) -> Void) {
        APIManager.s.user.reset(resetKey: resetKey) { error, data in
            if let error = error {
                callback(nil, error)
                return
            }
            UserDefaultsManager.s.identifierKey = data!.identifierKey
            UserDefaultsManager.s.accessKey = data!.accessKey
            callback(data, nil)
        }
    }
    
}

