import Foundation

final class AuthManager {
    
    static public let shared = AuthManager()
    private init() {}
    
    private var timer: Timer?
    
    private func authCheck(timerIn: Timer) -> Void {
        authCheckRequest()
    }
    
    private func authCheckRequest() {
        guard let keys = getAuthKeys() else { return }
        APIManager.shared.user.get(keys: keys) { error, data in
            guard let _ = error else { return }
            let _ = self.setAuthWindow()
        }
    }
    
    public func setAuthWindow(noAuth: Bool = false) {
        PlayerItemsManager.shared.removeDownloadableItems()
        PlayerManager.shared.clearPlayer()
        TracklistManager.shared.clear()
        let _ = stopAuthCheck()
        AuthRouter.setSelf(noAuth: noAuth)
    }
    
    public func startAuthCheck(startNow: Bool = false) -> Bool {
        if OfflineModeManager.shared.offlineMode { return false }
        if startNow {
            authCheckRequest()
        }
        guard let _ = timer else {
            timer = Timer.scheduledTimer(withTimeInterval: 60 * 2, repeats: true, block: authCheck)
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
        if let ikey = UserDefaultsManager.shared.identifierKey, let akey = UserDefaultsManager.shared.accessKey {
            return KeysPair(ikey, akey)
        }
        if setFailAuth {
            setAuthWindow()
        }
        return nil
    }
    
    public func authorization(keys: KeysPair? = nil, callback: @escaping (UserData?, NSError?) -> Void) {
        guard let keys = keys ?? getAuthKeys() else { return }
        APIManager.shared.user.get(keys: keys) { error, data in
            callback(data, error)
        }
    }
    
    public func registration(callback: @escaping (UserSecretData?, NSError?) -> Void) {
        APIManager.shared.user.register() { error, data in
            if let data = data {
                UserDefaultsManager.shared.identifierKey = data.identifierKey
                UserDefaultsManager.shared.accessKey = data.accessKey
            }
            callback(data, error)
        }
    }
    
    public func reset(resetKey: String, callback: @escaping (UserSecretData?, NSError?) -> Void) {
        APIManager.shared.user.reset(resetKey: resetKey) { error, data in
            if let data = data {
                UserDefaultsManager.shared.identifierKey = data.identifierKey
                UserDefaultsManager.shared.accessKey = data.accessKey
            }
            callback(data, error)
        }
    }
    
}

