import Foundation

class AuthPresenter: AuthPresenterProtocol {
    var router: AuthRouterProtocol!
    var interactor: AuthInteractorProtocol!
    weak var view: AuthViewControllerProtocol!
    
    func viewDidLoad() {
        view.setLabel("Загрузка...")
    }
    
    func viewDidAppear() {
        if interactor.noAuthOnShow {
            setAuthFormVisable()
            return
        }
        startAuth(ikey: nil, akey: nil)
    }
    
    func startAuth(ikey: Int?, akey: Int?) {
        view.setLabel("Получение информации...")
        let keys = interactor.getKeys()
        if let ikey = ikey ?? keys?.i, let akey = akey ?? keys?.a {
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
        if let (ikey, akey) = interactor.getKeys() {
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
        guard let (ikey, akey) = interactor.inputProcessing(input: identifierText) else {
            view.setLabel("Неверный формат идентификатора")
            view.enableButtons()
            return
        }
        startAuth(ikey: ikey, akey: akey)
    }
}
