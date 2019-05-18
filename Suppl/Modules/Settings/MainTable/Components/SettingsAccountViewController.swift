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
        navigationItem.title = "titleSAccount".localizeKey
        identifierLabel.text = "youIdentifierLabel".localizeKey
        accountOutButton.setTitle("identifierButton".localizeKey, for: .normal)
        emailLabel.text = "youEmailLabel".localizeKey
        emailButton.setTitle("emailButton".localizeKey, for: .normal)
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
        self.emailField.placeholder = "install".localizeKey
        APIManager.shared.user.updateEmail(keys: keys, email: email) { [weak self] error, data in
            guard let self = self else { return }
            if let error = error {
                self.emailField.placeholder = error.localizeError
            } else {
                self.emailField.placeholder = "emailSet".localizeKey
            }
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
                guard let self = self else { return }
                self.emailField.placeholder = lastPlacehilderText
                self.emailField.text = email
            }
        }
    }
    
    func setTheme() {
        emailButton.theme_backgroundColor = UIColor.Theme.second.picker
        accountOutButton.theme_backgroundColor = UIColor.Theme.second.picker
    }
    
    private func getAccount() {
        guard let keys = AuthManager.shared.getAuthKeys() else { return }
        if OfflineModeManager.shared.offlineMode {
            emailField.text = "noInOffline".localizeKey
            identifierField.text = String(keys.identifierKey) + String(keys.accessKey)
            emailButton.isHidden = true
            self.accountOutButton.isEnabled = true
            emailField.isEnabled = false
            identifierField.isEnabled = false
            return
        }
        let loadText: String = "getInfo".localizeKey
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
            self.emailField.placeholder = "youEmail".localizeKey
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

