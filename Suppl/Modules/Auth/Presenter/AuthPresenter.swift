import Foundation

class AuthPresenter: AuthPresenterProtocolInteractor, AuthPresenterProtocolView {
    
    var router: AuthRouterProtocol!
    var interactor: AuthInteractorProtocol!
    weak var view: AuthViewControllerProtocol!
    
    let noAuthOnShow: Bool
    
    let showDelay = 2.2
    
    init(noAuth noAuthOnShow: Bool = false) {
        self.noAuthOnShow = noAuthOnShow
    }
    
    func getButtonLabel() -> String {
        return interactor.getLocaleString(.loginIn)
    }
    
    func getResetStackStrings() -> (title: String, field: String, button: String) {
        let title = interactor.getLocaleString(.resetTitle)
        let field = interactor.getLocaleString(.youEmail)
        let button = interactor.getLocaleString(.send)
        return (title, field, button)
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
    
    func startAuth(fromString input: String? = nil, resetKey: String? = nil, onlyInfo: Bool = false) {
        interactor.startAuth(fromString: input, resetKey: resetKey, onlyInfo: onlyInfo)
    }
    
    func userResetKey(_ resetKey: String) {
        startAuth(resetKey: resetKey)
    }
    
    func setAuthStarted(isReg: Bool) {
        setLabel(expression: isReg ? .reg : .auth)
    }
    
    func setAuthResult(_ error: String?, blockOnError: Bool = false) {
        if let error = error {
            setLabel(error)
            if blockOnError { return }
            QueueTemplate.continueAfter(showDelay) { [weak self] in
                self?.setLabel(expression: .inputIdentifier)
                self?.view.enableButtons()
            }
        } else {
            setLabel(expression: .coreDataLoading)
            interactor.loadCoreData()
        }
    }
    
    func setRequestResetResult(_ errorId: Int?) {
        if let errorId = errorId {
            view.showToast(text: interactor.getLocaleString(apiErrorCode: errorId))
            view.enableResetForm(true, full: false)
        } else {
            view.showToast(text: interactor.getLocaleString(.keySent))
        }
    }
    
    func requestResetKey(forEmail email: String) {
        interactor.requestResetKey(forEmail: email)
    }
    
    func coreDataLoaded() {
        setLabel(expression: .hi)
        QueueTemplate.continueAfter(showDelay) { [weak self] in
            self?.interactor.startAuthCheck()
            self?.router.goToRootTabBar()
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
