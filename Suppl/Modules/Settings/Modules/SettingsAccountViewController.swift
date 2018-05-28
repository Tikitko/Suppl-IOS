import Foundation
import UIKit
import SwiftTheme

class SettingsAccountViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var identifierField: UITextField!
    @IBOutlet weak var accountOutButton: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LocalesManager.s.get(.titleSAccount)
        setTheme()
        getAccount()
        emailField.delegate = self
        identifierField.delegate = self
    }
    
    @IBAction func accountOutButtonClick(_ sender: Any) {
        UserDefaultsManager.s.identifierKey = nil
        UserDefaultsManager.s.accessKey = nil
        AuthManager.s.setAuthWindow(noAuth: true)
    }

    @IBAction func emailButtonClick(_ sender: Any) {
        view.endEditing(true)
        guard let keys = AuthManager.s.getAuthKeys() else { return }
        guard let email = self.emailField.text else { return }
        let lastPlacehilderText = emailField.placeholder
        self.emailField.text = ""
        self.emailField.placeholder = LocalesManager.s.get(.install)
        APIManager.s.userUpdateEmail(keys: keys, email: email) { [weak self] error, data in
            guard let `self` = self else { return }
            self.emailField.placeholder = error != nil ? LocalesManager.s.get(apiErrorCode: error!.code) : LocalesManager.s.get(.emailSet)
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
                guard let `self` = self else { return }
                self.emailField.placeholder = lastPlacehilderText
                self.emailField.text = email
            }
        }
    }
    
    func setTheme() {
        emailButton.theme_backgroundColor = "secondColor"
        accountOutButton.theme_backgroundColor = "secondColor"
    }
    
    private func getAccount() {
        let loadText: String = LocalesManager.s.get(.getInfo)
        emailField.text = loadText
        identifierField.text = loadText
        guard let keys = AuthManager.s.getAuthKeys() else { return }
        APIManager.s.userGet(keys: keys) { [weak self] error, data in
            guard let `self` = self else { return }
            guard let data = data else {
                AuthManager.s.setAuthWindow()
                return
            }
            self.emailButton.isEnabled = true
            self.emailField.placeholder = LocalesManager.s.get(.youEmail)
            self.emailField.text = data.email != nil ? data.email! : ""
            self.accountOutButton.isEnabled = true
            self.identifierField.text = String(keys.identifierKey) + String(keys.accessKey)
        }
    }
}

extension SettingsAccountViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = nil
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == identifierField {
            accountOutButtonClick(textField)
            return true
        }
        if textField == emailField {
            emailButtonClick(textField)
        }
        return false
    }
}

