import Foundation

class AuthInteractor: AuthInteractorProtocol {

    weak var presenter: AuthPresenterProtocol!
    
    let noAuthOnShow: Bool
    
    init(noAuth noAuthOnShow: Bool = false) {
        self.noAuthOnShow = noAuthOnShow
    }

    func show() {
        presenter.setLabel(LocalesManager.s.get(.load))
        if noAuthOnShow {
            setAuthFormVisable()
            return
        }
        startAuth(keys: nil)
    }
    
    func continueAfter(_ continueAfter: Double, timeOutCallback: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + continueAfter, execute: timeOutCallback)
    }
    
    func endAuth() {
        continueAfter(0.7) { [weak self] in
            guard let `self` = self else { return }
            self.presenter.goToRoot()
            TracklistManager.s.update() { status in }
        }
        let _ = AuthManager.s.startAuthCheck()
    }
    
    func setStatusCallback(_ status: String?) {
        if let error = status {
            presenter.setLabel(error)
            setAuthFormVisable(nowInputInfo: false)
        } else {
            presenter.setLabel(LocalesManager.s.get(.hi))
            endAuth()
        }
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
    
    func startAuth(keys: KeysPair?) {
        presenter.setLabel(LocalesManager.s.get(.getInfo))
        if let keys = keys ?? AuthManager.s.getAuthKeys(setFailAuth: false) {
            presenter.setLabel(LocalesManager.s.get(.auth))
            AuthManager.s.authorization(keys: keys, callback: setStatusCallback)
        } else {
            presenter.setLabel(LocalesManager.s.get(.reg))
            AuthManager.s.registration(callback: setStatusCallback)
        }
    }
    
    func setLabelForInput() {
        presenter.setLabel(LocalesManager.s.get(.inputIdentifier))
    }
    
    func setLabelForInputAfter(_ after: Double) {
        continueAfter(after, timeOutCallback: setLabelForInput)
    }
    
    func setAuthFormVisable(nowInputInfo: Bool = true, setSavedKays: Bool = true) {
        if nowInputInfo {
            setLabelForInput()
        } else {
            setLabelForInputAfter(1.5)
        }
        if setSavedKays {
            let keys = AuthManager.s.getAuthKeys(setFailAuth: false)
            presenter.setIdentifier(keys != nil ? "\(keys!.identifierKey)\(keys!.accessKey)" : "")
        }
        presenter.enableButtons()
    }
    
    func repeatButtonClick(identifierText: String?) {
        presenter.setLabel(LocalesManager.s.get(.checkIdentifier))
        presenter.disableButtons()
        guard inputProcessing(input: identifierText), let keys = AuthManager.s.getAuthKeys(setFailAuth: false) else {
            presenter.setLabel(LocalesManager.s.get(.badIdentifier))
            setAuthFormVisable(nowInputInfo: false, setSavedKays: false)
            return
        }
        startAuth(keys: keys)
    }
}
