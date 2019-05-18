import Foundation

class AuthInteractor: ViperInteractor<AuthPresenterProtocolInteractor>, AuthInteractorProtocol {
    
    func startAuthCheck() {
        let _ = AuthManager.shared.startAuthCheck()
    }
    
    func requestIdentifierString() {
        presenter.setIdentifier(AuthManager.shared.getAuthKeys(setFailAuth: false)?.string ?? String())
    }

    func startAuth(fromString input: String? = nil, resetKey: String? = nil, onlyInfo: Bool = false) {
        if OfflineModeManager.shared.offlineMode {
            if let _ = AuthManager.shared.getAuthKeys(setFailAuth: false) {
                presenter.setAuthResult(nil, blockOnError: false)
            } else {
                presenter.setAuthResult(localizationKey: "noOffline", blockOnError: true)
            }
            return
        }
        if onlyInfo {
            presenter.setAuthResult(localizationKey: "inputIdentifier", blockOnError: false)
            return
        }
        if let text = input {
            if let _ = Int(text), text.count % 2 == 0 {
                let half: Int = text.count / 2
                UserDefaultsManager.shared.identifierKey = Int(text[text.startIndex..<text.index(text.startIndex, offsetBy: half)])
                UserDefaultsManager.shared.accessKey = Int(text[text.index(text.startIndex, offsetBy: half)..<text.endIndex])
            } else {
                presenter.setAuthResult(localizationKey: "badIdentifier", blockOnError: false)
                return
            }
        }
        if let resetKey = resetKey {
            presenter.setAuthStarted(isReg: false)
            AuthManager.shared.reset(resetKey: resetKey) { [weak self] error, data in
                if let data = data {
                    self?.presenter.setIdentifier(KeysPair(data.identifierKey, data.accessKey).string)
                }
                self?.sendAuthResult(apiSessionError: error)
            }
        } else if let keys = AuthManager.shared.getAuthKeys(setFailAuth: false) {
            presenter.setAuthStarted(isReg: false)
            AuthManager.shared.authorization(keys: keys) { [weak self] error, data in
                self?.sendAuthResult(apiSessionError: error)
            }
        } else {
            presenter.setAuthStarted(isReg: true)
            AuthManager.shared.registration() { [weak self] error, data in
                self?.sendAuthResult(apiSessionError: error)
            }
        }
    }
    
    func requestResetKey(forEmail email: String) {
        APIManager.shared.user.sendResetKey(email: email) { [weak self] error, status in
            self?.presenter.setRequestResetResult(error?.localizeError)
        }
    }
    
    func loadCoreData() {
        CoreDataManager.shared.loadPersistentCoordinatorIfNeeded { [weak self] error in
            DispatchQueue.main.async {
                if let _ = error {
                    self?.presenter.setAuthResult(localizationKey: "coreDataLoadError", blockOnError: true)
                } else {
                    self?.presenter.coreDataLoaded()
                }
            }
        }
    }
    
    func sendAuthResult(apiSessionError: APISession.ResponseError?) {
        if let apiSessionError = apiSessionError {
            presenter.setAuthResult(errorString: apiSessionError.localizeError)
        } else {
            presenter.setAuthResult(nil, blockOnError: false)
        }
    }
    
}
