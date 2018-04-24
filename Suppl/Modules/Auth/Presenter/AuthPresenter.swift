import Foundation

class AuthPresenter: AuthPresenterProtocol {
    var router: AuthRouterProtocol!
    var interactor: AuthInteractorProtocol!
    weak var view: AuthViewControllerProtocol!
    
    func load() {
        view.setLabel("Загрузка...")
    }
    
    func show() {
        if interactor.noAuthOnShow {
            setAuthFormVisable()
            return
        }
        startAuth(ikey: nil, akey: nil)
    }
    
    func startAuth(ikey: Int?, akey: Int?) {
        view.setLabel("Получение информации...")
        let keys = AuthManager.getAuthKeys(setFailAuth: false)
        if let ikey = ikey ?? keys?.ikey, let akey = akey ?? keys?.akey {
            view.setLabel("Авторизация...")
            interactor.auth(ikey: ikey, akey: akey)
        } else {
            view.setLabel("Регистрация...")
            interactor.reg()
        }
    }
    
    func setAuthResult(error: String?) {
        if let error = error {
            view.setLabel(error)
            setAuthFormVisable()
        } else {
            view.setLabel("Добро пожаловать!")
            interactor.endAuth()
        }
    }
    
    func setAuthFormVisable() {
        if let (ikey, akey) = AuthManager.getAuthKeys(setFailAuth: false) {
            view.setIdentifier(String("\(ikey)\(akey)"))
        } else {
            view.setLabel("Введите ваш идентификатор")
            view.setIdentifier("")
        }
        view.enableButtons()
    }
    
    func goToRoot() {
        router.goToRootTabBar()
    }
    
    func repeatButtonClick(_ sender: Any, identifierText: String?) {
        view.setLabel("Проверка идентификатора")
        view.disableButtons()
        guard interactor.inputProcessing(input: identifierText), let (ikey, akey) = AuthManager.getAuthKeys(setFailAuth: false) else {
            view.setLabel("Неверный формат идентификатора")
            view.enableButtons()
            return
        }
        startAuth(ikey: ikey, akey: akey)
    }
}
