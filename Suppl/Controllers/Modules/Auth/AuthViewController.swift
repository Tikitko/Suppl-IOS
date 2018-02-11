import Foundation
import UIKit
import SwiftTheme

class AuthViewController: UIViewController {
    
    private var noAuthOnShow: Bool = false
    
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var identifierField: UITextField!
    @IBOutlet weak var repeatButton: UIButton!
    
    convenience init(noAuth noAuthOnShow: Bool?) {
        self.init(nibName: nil, bundle: nil)
        guard let noAuthOnShow = noAuthOnShow else { return }
        self.noAuthOnShow = noAuthOnShow
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        statusLabel.text = "Загрузка..."
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if noAuthOnShow {
            setAuthFormVisable()
            return
        }
        startAuth()
    }
    
    func setTheme() {
        //view.backgroundColor = AppData.getTheme(SettingsManager.theme).firstColor
        //identifierField.backgroundColor = AppData.getTheme(SettingsManager.theme).secondColor
        //repeatButton.backgroundColor = AppData.getTheme(SettingsManager.theme).secondColor
        view.theme_backgroundColor = "firstColor"
        identifierField.theme_backgroundColor = "secondColor"
        repeatButton.theme_backgroundColor = "secondColor"
    }
    
    @IBAction func repeatButtonClick(_ sender: Any) {
        guard let text = identifierField.text, let _ = Int(text), text.count % 2 == 0 else {
            statusLabel.text = "Неверный формат идентификатора"
            return
        }
        identifierField.isEnabled = false
        repeatButton.isEnabled = false
        statusLabel.text = "Проверка идентификатора"
        let half: Int = text.count / 2
        let ikey = Int(text[text.startIndex..<text.index(text.startIndex, offsetBy: half)])
        let akey = Int(text[text.index(text.startIndex, offsetBy: half)..<text.endIndex])
        UserDefaultsManager.identifierKey = ikey
        UserDefaultsManager.accessKey = akey
        startAuth(ikey: ikey, akey: akey)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardFrame = sender.userInfo![UIKeyboardFrameEndUserInfoKey] as? CGRect {
            view.frame.origin.y = -keyboardFrame.height
            logoLabel.isHidden = true
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        view.frame.origin.y = 0
        logoLabel.isHidden = false
    }
    
    private func endAuth() {
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) { [unowned self] in
            self.present(RootTabBarController(), animated: true)
            TracklistManager.update() { status in }
        }
        let _ = AuthManager.startAuthCheck()
    }
    
    private func setAuthFormVisable() {
        if let ikey = UserDefaultsManager.identifierKey, let akey = UserDefaultsManager.accessKey {
            identifierField.text = String("\(ikey)\(akey)")
        } else {
            statusLabel.text = "Введите ваш идентификатор"
            identifierField.text = ""
        }
        identifierField.isEnabled = true
        repeatButton.isEnabled = true
        identifierField.isHidden = false
        repeatButton.isHidden = false
    }
    
    private func auth(ikey: Int, akey: Int) {
        statusLabel.text = "Авторизация..."
        APIManager.userGet(ikey: ikey, akey: akey) { [unowned self] error, data in
            guard let error = error else {
                guard let _ = data else { return }
                self.setOkStatus()
                return
            }
            self.setErrorStatus(error: error)
        }
    }
    
    private func register() {
        statusLabel.text = "Регистрация..."
        APIManager.userRegister() { [unowned self] error, data in
            if let error = error {
                self.setErrorStatus(error: error)
                return
            }
            guard let data = data else { return }
            UserDefaultsManager.identifierKey = data.identifierKey
            UserDefaultsManager.accessKey = data.accessKey
            self.setOkStatus()
        }
    }
    
    private func setOkStatus() {
        statusLabel.text = "Добро пожаловать!"
        endAuth()
    }
    
    private func setErrorStatus(error: NSError) {
        statusLabel.text = APIManager.errorHandler(error)
        setAuthFormVisable()
    }
    
    private func startAuth(ikey: Int? = nil, akey: Int? = nil) {
        statusLabel.text = "Получение информации..."
        if let ikey = ikey ?? UserDefaultsManager.identifierKey, let akey = akey ?? UserDefaultsManager.accessKey {
            auth(ikey: ikey, akey: akey)
            return
        }
        register()
    }
}
