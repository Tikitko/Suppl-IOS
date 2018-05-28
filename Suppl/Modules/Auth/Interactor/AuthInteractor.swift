import Foundation

class AuthInteractor: BaseInteractor, AuthInteractorProtocol {

    weak var presenter: AuthPresenterProtocolInteractor!
    
    func startAuthCheck() {
        let _ = AuthManager.s.startAuthCheck()
    }

    func startAuth(fromString input: String? = nil, onlyInfo: Bool = false) {
        if onlyInfo {
            presenter.setAuthResult(.inputIdentifier)
            return
        }
        if let text = input {
            if let _ = Int(text), text.count % 2 == 0 {
                let half: Int = text.count / 2
                UserDefaultsManager.s.identifierKey = Int(text[text.startIndex..<text.index(text.startIndex, offsetBy: half)])
                UserDefaultsManager.s.accessKey = Int(text[text.index(text.startIndex, offsetBy: half)..<text.endIndex])
            } else {
                presenter.setAuthResult(.badIdentifier)
                return
            }
        }
        
        if let keys = getKeys() {
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
    
    private func sendAuthResult(_ error: NSError?) {
        if let error = error {
            presenter.setAuthResult(apiErrorCode: error.code)
        } else {
            presenter.setAuthResult(nil)
        }
    }

    override func getKeys() -> KeysPair? {
        return AuthManager.s.getAuthKeys(setFailAuth: false)
    }
    
}
