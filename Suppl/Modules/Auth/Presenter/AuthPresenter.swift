import Foundation

class AuthPresenter: AuthPresenterProtocol {
    
    var router: AuthRouterProtocol!
    var interactor: AuthInteractorProtocol!
    weak var view: AuthViewControllerProtocol!
    
    let noAuthOnShow: Bool
    
    init(noAuth noAuthOnShow: Bool = false) {
        self.noAuthOnShow = noAuthOnShow
    }
    
    func setLabel(expression: LocalesManager.Expression) {
        view.setLabel(interactor.getLocaleString(expression))
    }
    
    func setLabel(_ str: String) {
        view.setLabel(str)
    }
    
    func setLoadLabel() {
        setLabel(expression: .load)
    }
    
    func firstStartAuth() {
        view.setIdentifier(interactor.getKeys()?.toString() ?? "")
        if !noAuthOnShow {
            startAuth()
        } else {
            setAuthResult(interactor.getLocaleString(.inputIdentifier))
        }
    }
    
    func startAuth(keys: KeysPair? = nil) {
        setLabel(expression: interactor.startAuth(keys: keys) ? .auth : .reg)
    }
    
    func setAuthResult(_ error: String?) {
        if let error = error {
            setLabel(error)
            QueueTemplate.continueAfter(1.7, timeOutCallback: enableForm)
        } else {
            setLabel(expression: .hi)
            QueueTemplate.continueAfter(0.7, timeOutCallback: endAuth)
        }
    }

    func enableForm() {
        setLabel(expression: .inputIdentifier)
        view.enableButtons()
    }
    
    func endAuth() {
        router.goToRootTabBar()
        interactor.tracklistUpdate()
        interactor.startAuthCheck()
    }
    
    func repeatButtonClick(identifierText: String?) {
        setLabel(expression: .checkIdentifier)
        view.disableButtons()
        if interactor.setKeysByString(input: identifierText) {
            startAuth(keys: interactor.getKeys())
        } else {
            setAuthResult(interactor.getLocaleString(.badIdentifier))
        }
    }

}
