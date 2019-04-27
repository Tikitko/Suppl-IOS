import Foundation
import UIKit

class SettingsAccountViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var identifierField: UITextField!
    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var accountOutButton: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LocalesManager.shared.get(.titleSAccount)
        identifierLabel.text = LocalesManager.shared.get(.youIdentifierLabel)
        accountOutButton.setTitle(LocalesManager.shared.get(.identifierButton), for: .normal)
        emailLabel.text = LocalesManager.shared.get(.youEmailLabel)
        emailButton.setTitle(LocalesManager.shared.get(.emailButton), for: .normal)
        setTheme()
        getAccount()
        emailField.delegate = self
        identifierField.delegate = self
        
        emailButton.layer.cornerRadius = 5
        emailButton.clipsToBounds = true
        accountOutButton.layer.cornerRadius = 5
        accountOutButton.clipsToBounds = true
    }
    
    @IBAction func accountOutButtonClick(_ sender: Any) {
        UserDefaultsManager.shared.identifierKey = nil
        UserDefaultsManager.shared.accessKey = nil
        AuthManager.shared.setAuthWindow(noAuth: true)
    }

    @IBAction func emailButtonClick(_ sender: Any) {
        view.endEditing(true)
        if OfflineModeManager.shared.offlineMode { return }
        guard let keys = AuthManager.shared.getAuthKeys() else { return }
        guard let email = self.emailField.text else { return }
        let lastPlacehilderText = emailField.placeholder
        self.emailField.text = String()
        self.emailField.placeholder = LocalesManager.shared.get(.install)
        APIManager.shared.user.updateEmail(keys: keys, email: email) { [weak self] error, data in
            guard let self = self else { return }
            self.emailField.placeholder = error != nil ? LocalesManager.shared.get(apiErrorCode: error!.code) : LocalesManager.shared.get(.emailSet)
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
                guard let self = self else { return }
                self.emailField.placeholder = lastPlacehilderText
                self.emailField.text = email
            }
        }
    }
    
    func setTheme() {
        emailButton.theme_backgroundColor = ThemeColor.second.picker
        accountOutButton.theme_backgroundColor = ThemeColor.second.picker
    }
    
    private func getAccount() {
        guard let keys = AuthManager.shared.getAuthKeys() else { return }
        if OfflineModeManager.shared.offlineMode {
            emailField.text = LocalesManager.shared.get(.noInOffline)
            identifierField.text = String(keys.identifierKey) + String(keys.accessKey)
            emailButton.isHidden = true
            self.accountOutButton.isEnabled = true
            emailField.isEnabled = false
            identifierField.isEnabled = false
            return
        }
        let loadText: String = LocalesManager.shared.get(.getInfo)
        emailField.isEnabled = false
        emailField.text = loadText
        identifierField.text = loadText
        APIManager.shared.user.get(keys: keys) { [weak self] error, data in
            guard let self = self else { return }
            guard let data = data else {
                AuthManager.shared.setAuthWindow()
                return
            }
            self.emailField.isEnabled = true
            self.emailButton.isEnabled = true
            self.emailField.placeholder = LocalesManager.shared.get(.youEmail)
            self.emailField.text = data.email ?? String()
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

