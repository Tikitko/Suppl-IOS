import Foundation

class AuthPresenter: AuthPresenterProtocolInteractor, AuthPresenterProtocolView {
    
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
        interactor.requestIdentifierString()
        startAuth(onlyInfo: noAuthOnShow)
    }
    
    func setIdentifier(_ string: String) {
        view.setIdentifier(string)
    }
    
    func startAuth(fromString input: String? = nil, onlyInfo: Bool = false) {
        interactor.startAuth(fromString: input, onlyInfo: onlyInfo)
    }
    
    func setAuthStarted(isReg: Bool) {
        setLabel(expression: isReg ? .reg : .auth)
    }
    
    func setAuthResult(_ error: String?, blockOnError: Bool = false) {
        if let error = error {
            setLabel(error)
            if blockOnError { return }
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
    
    func setAuthResult(_ expression: LocalesManager.Expression, blockOnError: Bool = false) {
        setAuthResult(interactor.getLocaleString(expression), blockOnError: blockOnError)
    }
    
    func setAuthResult(apiErrorCode code: Int) {
        setAuthResult(interactor.getLocaleString(apiErrorCode: code))
    }
    
    func repeatButtonClick(identifierText: String?) {
        guard let identifierText = identifierText else { return }
        view.disableButtons()
        setLabel(expression: .checkIdentifier)
        startAuth(fromString: identifierText)
    }

}
