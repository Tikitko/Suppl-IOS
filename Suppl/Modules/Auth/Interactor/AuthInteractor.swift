import Foundation

class AuthInteractor: AuthInteractorProtocol {

    weak var presenter: AuthPresenterProtocol!
    
    let noAuthOnShow: Bool
    
    init(noAuth noAuthOnShow: Bool = false) {
        self.noAuthOnShow = noAuthOnShow
    }
    
    func endAuth() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            guard let `self` = self else { return }
            self.presenter.goToRoot()
            TracklistManager.s.update() { status in }
        }
        presenter.goToRoot()
        TracklistManager.s.update() { status in }
        let _ = AuthManager.s.startAuthCheck()
    }
    
    func auth(keys: KeysPair?) {
        AuthManager.s.authorization(keys: keys, callback: setStatusCallback)
    }
    
    func reg() {
        AuthManager.s.registration(callback: setStatusCallback)
    }
    
    func setStatusCallback(_ status: String?) {
        presenter.setAuthResult(error: status)
    }
    
    func inputProcessing(input: String?) -> Bool {
        if let text = input, let _ = Int(text), text.count % 2 == 0 {
            let half: Int = text.count / 2
            UserDefaultsManager.s.identifierKey = Int(text[text.startIndex..<text.index(text.startIndex, offsetBy: half)])
            UserDefaultsManager.s.accessKey = Int(text[text.index(text.startIndex, offsetBy: half)..<text.endIndex])
            return true
        }
        return false
    }
}
