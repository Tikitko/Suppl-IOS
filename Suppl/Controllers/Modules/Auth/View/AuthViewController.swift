import Foundation
import UIKit
import SwiftTheme

class AuthViewController: UIViewController, AuthViewControllerProtocol {
    
    var presenter: AuthPresenter!
    
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var identifierField: UITextField!
    @IBOutlet weak var repeatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.theme_backgroundColor = "firstColor"
        identifierField.theme_backgroundColor = "secondColor"
        repeatButton.theme_backgroundColor = "secondColor"
        statusLabel.text = "Загрузка..."
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if presenter.getNoAuthOnShow() {
            setAuthFormVisable()
            return
        }
        startAuth()
    }
    
    private func setAuthFormVisable() {
        if let (ikey, akey) = presenter.getKeys() {
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
    
    private func startAuth(ikey: Int? = nil, akey: Int? = nil) {
        statusLabel.text = "Получение информации..."
        let keys = presenter.getKeys()
        if let ikey = ikey ?? keys?.i, let akey = akey ?? keys?.a {
            auth(ikey: ikey, akey: akey)
        } else {
            register()
        }
    }
    
    private func auth(ikey: Int, akey: Int) {
        statusLabel.text = "Авторизация..."
        presenter.auth(ikey: ikey, akey: akey) { [weak self] error in
            guard let `self` = self else { return }
            self.setResult(error: error)
        }
    }
    
    private func register() {
        statusLabel.text = "Регистрация..."
        presenter.reg() { [weak self] error in
            guard let `self` = self else { return }
            self.setResult(error: error)
        }
    }
    
    private func setResult(error: String?) {
        if let error = error {
            statusLabel.text = error
            setAuthFormVisable()
        } else {
            statusLabel.text = "Добро пожаловать!"
            presenter.endAuth()
        }
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
    
    // -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    @IBAction func repeatButtonClick(_ sender: Any) {
        if let text = identifierField.text, let _ = Int(text), text.count % 2 == 0 {
            statusLabel.text = "Проверка идентификатора"
            identifierField.isEnabled = false
            repeatButton.isEnabled = false
            let half: Int = text.count / 2
            let ikey = Int(text[text.startIndex..<text.index(text.startIndex, offsetBy: half)])
            let akey = Int(text[text.index(text.startIndex, offsetBy: half)..<text.endIndex])
            UserDefaultsManager.identifierKey = ikey
            UserDefaultsManager.accessKey = akey
            startAuth(ikey: ikey, akey: akey)
        } else {
            statusLabel.text = "Неверный формат идентификатора"
        }
    }
}
