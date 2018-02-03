import Foundation
import UIKit

class SettingsAccountViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var identifierField: UITextField!
    @IBOutlet weak var accountOutButton: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.title = "Аккаунт"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAccount()
    }
    
    @IBAction func accountOutButtonClick(_ sender: Any) {
        UserDefaultsManager.identifierKey = nil
        UserDefaultsManager.accessKey = nil
        AuthManager.setAuthWindow(noAuth: true)
    }

    @IBAction func emailButtonClick(_ sender: Any) {
        view.endEditing(true)
        guard let ikey = UserDefaultsManager.identifierKey, let akey = UserDefaultsManager.accessKey else {
            AuthManager.setAuthWindow()
            return
        }
        guard let email = self.emailField.text else { return }
        self.emailField.text = "Установка..."
        APIManager.userUpdateEmail(ikey: ikey, akey: akey, email: email) { [weak self] error, data in
            guard let `self` = self else { return }
            if let error = error {
                self.emailField.text = APIManager.errorHandler(error)
                return
            }
            self.emailField.text = "EMail установлен!"
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
                guard let `self` = self else { return }
                self.emailField.text = email
            }
        }
    }
    
    private func getAccount() {
        let loadText = "Получение данных..."
        emailField.text = loadText
        identifierField.text = loadText
        guard let ikey = UserDefaultsManager.identifierKey, let akey = UserDefaultsManager.accessKey else {
            AuthManager.setAuthWindow()
            return
        }
        APIManager.userGet(ikey: ikey, akey: akey) { [weak self] error, data in
            guard let `self` = self else { return }
            guard let data = data else {
                AuthManager.setAuthWindow()
                return
            }
            self.emailButton.isEnabled = true
            self.emailField.text = data.email ?? "EMail не установлен"
            self.accountOutButton.isEnabled = true
            self.identifierField.text = String(ikey) + String(akey)
        }
    }
}

