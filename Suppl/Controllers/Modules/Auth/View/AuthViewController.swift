import Foundation
import UIKit
import SwiftTheme

class AuthViewController: UIViewController, AuthViewControllerProtocol {
    
    var presenter: AuthPresenterProtocol!
    
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var identifierField: UITextField!
    @IBOutlet weak var repeatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    
    func setTheme() {
        view.theme_backgroundColor = "firstColor"
        identifierField.theme_backgroundColor = "secondColor"
        repeatButton.theme_backgroundColor = "secondColor"
    }
    
    func setLabel(_ text: String) {
        statusLabel.text = text
    }
    
    func setIdentifier(_ text: String) {
        identifierField.text = text
    }
    
    func enableButtons() {
        identifierField.isEnabled = true
        repeatButton.isEnabled = true
        identifierField.isHidden = false
        repeatButton.isHidden = false
    }
    
    func disableButtons() {
        identifierField.isEnabled = false
        repeatButton.isEnabled = false
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
    
    @IBAction func repeatButtonClick(_ sender: Any) {
        presenter.repeatButtonClick(sender, identifierText: identifierField.text)
    }
    
}