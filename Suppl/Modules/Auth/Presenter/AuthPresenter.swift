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
        startAuth(onlyInfo: noAuthOnShow)
    }
    
    func startAuth(fromString input: String? = nil, onlyInfo: Bool = false) {
        interactor.startAuth(fromString: input, onlyInfo: onlyInfo)
    }
    
    func setAuthStarted(isReg: Bool) {
        setLabel(expression: isReg ? .reg : .auth)
    }
    
    func setAuthResult(_ error: String?) {
        if let error = error {
            setLabel(error)
            QueueTemplate.continueAfter(1.7) { [weak self] in
                self?.setLabel(expression: .inputIdentifier)
                self?.view.enableButtons()
            }
        } else {
            setLabel(expression: .hi)
            QueueTemplate.continueAfter(0.7) { [weak self] in
                self?.interactor.startAuthCheck()
                self?.router.goToRootTabBar()
            }
        }
    }
    
    func setAuthResult(_ expression: LocalesManager.Expression) {
        setAuthResult(interactor.getLocaleString(expression))
    }
    
    func repeatButtonClick(identifierText: String?) {
        guard let identifierText = identifierText else { return }
        view.disableButtons()
        setLabel(expression: .checkIdentifier)
        startAuth(fromString: identifierText)
    }

}
