import Foundation

class AuthPresenter: AuthPresenterProtocol {
    
    var router: AuthRouterProtocol!
    var interactor: AuthInteractorProtocol!
    weak var view: AuthViewControllerProtocol!
    
    func show() {
        interactor.show()
    }
    
    func goToRoot() {
        router.goToRootTabBar()
    }
    
    func repeatButtonClick(identifierText: String?) {
        interactor.repeatButtonClick(identifierText: identifierText)
    }
    
    func enableButtons() {
        view.enableButtons()
    }
    
    func disableButtons() {
        view.disableButtons()
    }
    
    func setLabel(_ text: String) {
        view.setLabel(text)
    }
    
    func setIdentifier(_ text: String) {
        view.setIdentifier(text)
    }
    
}
