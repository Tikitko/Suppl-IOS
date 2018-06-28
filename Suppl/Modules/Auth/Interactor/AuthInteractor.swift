import Foundation

class AuthInteractor: BaseInteractor, AuthInteractorProtocol {

    weak var presenter: AuthPresenterProtocolInteractor!
    
    func startAuthCheck() {
        let _ = AuthManager.s.startAuthCheck()
    }
    
    func requestIdentifierString() {
        presenter.setIdentifier(AuthManager.s.getAuthKeys(setFailAuth: false)?.string ?? "")
    }

    func startAuth(fromString input: String? = nil, onlyInfo: Bool = false) {
        if OfflineModeManager.s.offlineMode {
            if let _ = AuthManager.s.getAuthKeys(setFailAuth: false) {
                presenter.setAuthResult(nil, blockOnError: false)
            } else {
                presenter.setAuthResult(.noOffline, blockOnError: true)
            }
            return
        }
        if onlyInfo {
            presenter.setAuthResult(.inputIdentifier, blockOnError: false)
            return
        }
        if let text = input {
            if let _ = Int(text), text.count % 2 == 0 {
                let half: Int = text.count / 2
                UserDefaultsManager.s.identifierKey = Int(text[text.startIndex..<text.index(text.startIndex, offsetBy: half)])
                UserDefaultsManager.s.accessKey = Int(text[text.index(text.startIndex, offsetBy: half)..<text.endIndex])
            } else {
                presenter.setAuthResult(.badIdentifier, blockOnError: false)
                return
            }
        }
        
        if let keys = AuthManager.s.getAuthKeys(setFailAuth: false) {
            presenter.setAuthStarted(isReg: false)
            AuthManager.s.authorization(keys: keys) { [weak self] data, error in
                self?.sendAuthResult(error)
            }
        } else {
            presenter.setAuthStarted(isReg: true)
            AuthManager.s.registration() { [weak self] data, error in
                self?.sendAuthResult(error)
            }
        }
    }
    
    func loadCoreData() {
        CoreDataManager.s.initStack() { [weak self] error in
            if let _ = error {
                self?.presenter.setAuthResult(.coreDataLoadError, blockOnError: true)
            } else {
                self?.presenter.coreDataLoaded()
            }
        }
    }
    
    func sendAuthResult(_ error: NSError?) {
        if let error = error {
            presenter.setAuthResult(apiErrorCode: error.code)
        } else {
            presenter.setAuthResult(nil, blockOnError: false)
        }
    }
    
}
