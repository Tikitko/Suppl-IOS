import Foundation
import UIKit
import SwiftTheme

class AuthViewController: UIViewController, AuthViewControllerProtocol {
    
    var presenter: AuthPresenterProtocolView!
    
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var identifierField: UITextField!
    @IBOutlet weak var repeatButton: UIButton!
    
    var logo: AnimateLogo!
    var animInWork = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        logoLabel.isHidden = true
        initLogo()
        repeatButton.setTitle(presenter.getButtonLabel(), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        presenter.setLoadLabel()
    }
    
    func initLogo() {
        logo = AnimateLogo.init("Suppl", color: .white, fontName: "System Light")
        view.addSubview(logo.view)
        let height = logo.view.frame.size.height
        let width = logo.view.frame.size.width
        logo.view.translatesAutoresizingMaskIntoConstraints = false
        logo.view.centerXAnchor.constraint(equalTo: logoLabel.centerXAnchor).isActive = true
        logo.view.centerYAnchor.constraint(equalTo: logoLabel.centerYAnchor).isActive = true
        logo.view.heightAnchor.constraint(equalToConstant: height).isActive = true
        logo.view.widthAnchor.constraint(equalToConstant: width).isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnim()
        presenter.firstStartAuth()
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
        stopAnim()
    }
    
    func disableButtons() {
        identifierField.isEnabled = false
        repeatButton.isEnabled = false
        startAnim()
    }
    
    func startAnim() {
        guard !animInWork else { return }
        animInWork = true
        logo.startAnim()
    }
    
    func stopAnim() {
        guard animInWork else { return }
        animInWork = false
        logo.stopAnim()
    }
    
    func goButton() {
        presenter.repeatButtonClick(identifierText: identifierField.text)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardFrame = sender.userInfo![UIKeyboardFrameEndUserInfoKey] as? CGRect {
            view.frame.origin.y = -keyboardFrame.height
            logo.view.isHidden = true
        }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        view.frame.origin.y = 0
        logo.view.isHidden = false
    }
    
    @IBAction func repeatButtonClick(_ sender: Any) {
        goButton()
    }
    
}

extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = nil
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(false)
        goButton()
        return true
    }
    
}
