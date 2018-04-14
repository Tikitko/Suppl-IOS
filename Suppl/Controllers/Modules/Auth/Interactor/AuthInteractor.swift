import Foundation

class AuthInteractor: AuthInteractorProtocol {
    
    weak var presenter: AuthPresenterProtocol!
    
    var noAuthOnShow = false
    
    func getKeys() -> (i: Int, a: Int)? {
        if let ikey = UserDefaultsManager.identifierKey, let akey = UserDefaultsManager.accessKey {
            return (ikey, akey)
        }
        return nil
    }
    
    func endAuth() {
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
            guard let `self` = self else { return }
            self.presenter.goToRoot()
            TracklistManager.update() { status in }
        }
        let _ = AuthManager.startAuthCheck()
    }
    
    func auth(ikey: Int, akey: Int, report: @escaping (String?) -> ()) {
        APIManager.userGet(ikey: ikey, akey: akey) { error, data in
            guard let error = error else {
                guard let _ = data else { return }
                report(nil)
                return
            }
            report(APIManager.errorHandler(error))
        }
    }
    
    func reg(report: @escaping (String?) -> ()) {
        APIManager.userRegister() { error, data in
            if let error = error {
                report(APIManager.errorHandler(error))
                return
            }
            guard let data = data else { return }
            UserDefaultsManager.identifierKey = data.identifierKey
            UserDefaultsManager.accessKey = data.accessKey
            report(nil)
        }
    }
    
    func inputProcessing(input: String?) -> (ikey: Int, akey: Int)? {
        if let text = input, let _ = Int(text), text.count % 2 == 0 {
            let half: Int = text.count / 2
            let ikey = Int(text[text.startIndex..<text.index(text.startIndex, offsetBy: half)])
            let akey = Int(text[text.index(text.startIndex, offsetBy: half)..<text.endIndex])
            UserDefaultsManager.identifierKey = ikey
            UserDefaultsManager.accessKey = akey
            return (ikey!, akey!)
        }
        return nil
    }
}
