import Foundation

class AuthInteractor: BaseInteractor, AuthInteractorProtocol {

    weak var presenter: AuthPresenterProtocol!
    
    func tracklistUpdate() {
        TracklistManager.s.update() { status in }
    }
    
    func startAuthCheck() {
        let _ = AuthManager.s.startAuthCheck()
    }
    
    func auth(keys: KeysPair?) {
        AuthManager.s.authorization(keys: keys) { [weak self] error in
            self?.presenter.setAuthResult(error)
        }
    }
    
    func reg() {
        AuthManager.s.registration() { [weak self] error in
            self?.presenter.setAuthResult(error)
        }
    }
    
    func startAuth(keys: KeysPair? = nil) -> Bool {
        if let keys = keys ?? getKeys() {
            auth(keys: keys)
            return true
        }
        reg()
        return false
    }
    
    func setKeysByString(input: String?) -> Bool {
        if let text = input, let _ = Int(text), text.count % 2 == 0 {
            let half: Int = text.count / 2
            UserDefaultsManager.s.identifierKey = Int(text[text.startIndex..<text.index(text.startIndex, offsetBy: half)])
            UserDefaultsManager.s.accessKey = Int(text[text.index(text.startIndex, offsetBy: half)..<text.endIndex])
            return true
        }
        return false
    }

    override func getKeys() -> KeysPair? {
        return AuthManager.s.getAuthKeys(setFailAuth: false)
    }
    
}
