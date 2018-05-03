import Foundation

class AuthPresenter: AuthPresenterProtocol {
    var router: AuthRouterProtocol!
    var interactor: AuthInteractorProtocol!
    weak var view: AuthViewControllerProtocol!
    
    func load() {
        view.setLabel(LocalesManager.s.get(.load))
    }
    
    func show() {
        if interactor.noAuthOnShow {
            setAuthFormVisable()
            return
        }
        startAuth(keys: nil)
    }
    
    func startAuth(keys: KeysPair?) {
        view.setLabel(LocalesManager.s.get(.getInfo))
        if let keys = keys ?? AuthManager.s.getAuthKeys(setFailAuth: false) {
            view.setLabel(LocalesManager.s.get(.auth))
            interactor.auth(keys: keys)
        } else {
            view.setLabel(LocalesManager.s.get(.reg))
            interactor.reg()
        }
    }
    
    func setAuthResult(error: String?) {
        if let error = error {
            view.setLabel(error)
            setAuthFormVisable()
        } else {
            view.setLabel(LocalesManager.s.get(.hi))
            interactor.endAuth()
        }
    }
    
    func setAuthFormVisable() {
        if let keys = AuthManager.s.getAuthKeys(setFailAuth: false) {
            view.setIdentifier(String("\(keys.identifierKey)\(keys.accessKey)"))
        } else {
            view.setLabel(LocalesManager.s.get(.inputIdentifier))
            view.setIdentifier("")
        }
        view.enableButtons()
    }
    
    func goToRoot() {
        router.goToRootTabBar()
    }
    
    func repeatButtonClick(identifierText: String?) {
        view.setLabel(LocalesManager.s.get(.checkIdentifier))
        view.disableButtons()
        guard interactor.inputProcessing(input: identifierText), let keys = AuthManager.s.getAuthKeys(setFailAuth: false) else {
            view.setLabel(LocalesManager.s.get(.badIdentifier))
            view.enableButtons()
            return
        }
        startAuth(keys: keys)
    }
}
