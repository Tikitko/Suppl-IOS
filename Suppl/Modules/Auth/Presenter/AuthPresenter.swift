import Foundation

class AuthPresenter: ViperPresenter<AuthRouterProtocol, AuthInteractorProtocol, AuthViewControllerProtocol>, AuthPresenterProtocolView, AuthPresenterProtocolInteractor {
    
    let noAuthOnShow: Bool
    
    let showDelay = 2.2
    
    required init(moduleId: String, parentModuleId: String?, args: [String : Any]) {
        self.noAuthOnShow = (args["noAuthOnShow"] as? Bool) ?? false
        super.init()
    }
    
    func getButtonLabel() -> String {
        return "loginIn".localizeKey
    }
    
    func getResetStackStrings() -> (title: String, field: String, button: String) {
        let title = "resetTitle".localizeKey
        let field = "youEmail".localizeKey
        let button = "send".localizeKey
        return (title, field, button)
    }
    
    func setLabel(localizationKey: String) {
        view.setLabel(localizationKey.localizeKey)
    }
    
    func setLabel(_ str: String) {
        view.setLabel(str)
    }
    
    func setLoadLabel() {
        setLabel(localizationKey: "load")
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
        interactor.requestIdentifierString()
        startAuth(resetKey: resetKey)
    }
    
    func setAuthStarted(isReg: Bool) {
        setLabel(localizationKey: isReg ? "reg" : "auth")
    }
    
    func setAuthResult(_ error: String?, blockOnError: Bool = false) {
        if let error = error {
            setLabel(error)
            if blockOnError { return }
            DispatchQueue.continueAfter(showDelay) { [weak self] in
                self?.setLabel(localizationKey: "inputIdentifier")
                self?.view.enableButtons()
                self?.view.stopAnim()
            }
        } else {
            setLabel(localizationKey: "coreDataLoading")
            interactor.loadCoreData()
        }
    }
    
    func setRequestResetResult(_ errorString: String?) {
        if let errorString = errorString {
            view.showToast(errorString)
            view.enableResetForm(true, full: false)
        } else {
            view.showToast("keySent".localizeKey)
        }
    }
    
    func requestResetKey(forEmail email: String) {
        interactor.requestResetKey(forEmail: email)
    }
    
    func coreDataLoaded() {
        setLabel(localizationKey: "hi")
        DispatchQueue.continueAfter(showDelay) { [weak self] in
            self?.interactor.startAuthCheck()
            self?.router.goToRootTabBar()
        }
    }
    
    func setAuthResult(localizationKey: String, blockOnError: Bool = false) {
        setAuthResult(localizationKey.localizeKey, blockOnError: blockOnError)
    }
    
    func setAuthResult(errorString: String) {
        setAuthResult(errorString)
    }
    
    func repeatButtonClick(identifierText: String?) {
        guard let identifierText = identifierText else { return }
        view.disableButtons()
        view.startAnim()
        setLabel(localizationKey: "checkIdentifier")
        startAuth(fromString: identifierText)
    }

}
