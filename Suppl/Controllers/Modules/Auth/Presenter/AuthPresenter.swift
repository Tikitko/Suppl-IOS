import Foundation

class AuthPresenter: AuthPresenterProtocol {
    var router: AuthRouterProtocol!
    var interactor: AuthInteractorProtocol!
    weak var view: AuthViewControllerProtocol!
    
    func viewDidLoad() {
        view.setLabel("Загрузка...")
        view.setTheme()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func viewDidAppear(_ animated: Bool) {
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
            auth(ikey: ikey, akey: akey)
        } else {
            register()
        }
    }
    
    func auth(ikey: Int, akey: Int) {
        view.setLabel("Авторизация...")
        interactor.auth(ikey: ikey, akey: akey) { [weak self] error in
            guard let `self` = self else { return }
            self.setResult(error: error)
        }
    }
    
    func register() {
        view.setLabel("Регистрация...")
        interactor.reg() { [weak self] error in
            guard let `self` = self else { return }
            self.setResult(error: error)
        }
    }
    
    func setResult(error: String?) {
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
    
    @objc func keyboardWillShow(sender: NSNotification) {
        view.keyboardWillShow(sender: sender)
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        view.keyboardWillHide(sender: sender)
    }
}
