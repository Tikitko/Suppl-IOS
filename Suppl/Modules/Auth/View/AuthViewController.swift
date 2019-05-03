import Foundation
import UIKit

class AuthViewController: UIViewController, AuthViewControllerProtocol {
    
    var presenter: AuthPresenterProtocolView!
    
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var identifierField: UITextField!
    @IBOutlet weak var repeatButton: UIButton!
    
    @IBOutlet weak var resetOpenButton: UIButton!
    @IBOutlet weak var resetStackView: UIStackView!
    @IBOutlet weak var resetTitleLabel: UILabel!
    @IBOutlet weak var resetEmailField: UITextField!
    @IBOutlet weak var resetSendButton: UIButton!
    
    var logoView: AnimateLogoView?
    var animInWork = false
    
    var resetKey: String?
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        initLogo()
        initResetStack()
        repeatButton.setTitle(presenter.getButtonLabel(), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        presenter.setLoadLabel()
        repeatButton.layer.cornerRadius = 4
        repeatButton.clipsToBounds = true
        resetSendButton.layer.cornerRadius = 4
        resetSendButton.clipsToBounds = true
        identifierField.isHidden = true
        repeatButton.isHidden = true
        enableResetForm(false, full: true)
    }

    func initLogo() {
        logoLabel.isHidden = true
        let logo = AnimateLogoView(logoLabel.text ?? String(), color: logoLabel.textColor ?? .white, fontName: logoLabel.font.fontName, fontSize: logoLabel.font.pointSize)
        view.addSubview(logo)
        let height = logo.frame.size.height
        let width = logo.frame.size.width
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.centerXAnchor.constraint(equalTo: logoLabel.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: logoLabel.centerYAnchor).isActive = true
        logo.heightAnchor.constraint(equalToConstant: height).isActive = true
        logo.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.logoView = logo
    }
    
    func initResetStack() {
        let localedStrings = presenter.getResetStackStrings()
        enableResetForm(false)
        resetOpenButton.isHidden = true
        resetEmailField.text = String()
        resetEmailField.attributedPlaceholder = NSAttributedString(
            string: localedStrings.field,
            attributes: [.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)]
        )
        resetTitleLabel.text = localedStrings.title
        resetSendButton.setTitle(localedStrings.button, for: .normal)
        resetOpenButton.setTitle(localedStrings.title, for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnim()
        if let resetKey = resetKey {
            self.resetKey = nil
            presenter.userResetKey(resetKey)
        } else {
            presenter.firstStartAuth()
        }
    }

    func setTheme() {
        view.theme_backgroundColor = UIColor.Theme.first.picker
        identifierField.theme_backgroundColor = UIColor.Theme.second.picker
        repeatButton.theme_backgroundColor = UIColor.Theme.second.picker
        resetEmailField.theme_backgroundColor = UIColor.Theme.second.picker
        resetSendButton.theme_backgroundColor = UIColor.Theme.second.picker
    }
    
    func enableResetForm(_ enabled: Bool, full: Bool = true) {
        if full {
            resetStackView.isHidden = !enabled
        } else {
            resetSendButton.isEnabled = enabled
            resetEmailField.isEnabled = enabled
        }
    }
    
    func showToast(_ text: String) {
        view.makeToast(text, duration: 2.0, position: .center)
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
        resetOpenButton.isEnabled = true
        identifierField.isHidden = false
        repeatButton.isHidden = false
        if resetStackView.isHidden {
            resetOpenButton.isHidden = false
        }
    }
    
    func disableButtons() {
        identifierField.isEnabled = false
        repeatButton.isEnabled = false
        resetOpenButton.isEnabled = false
    }
    
    func startAnim() {
        guard !animInWork else { return }
        animInWork = true
        logoView?.startAnim()
    }
    
    func stopAnim() {
        guard animInWork else { return }
        animInWork = false
        logoView?.stopAnim()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        view.frame.origin.y = -keyboardFrame.height / (resetEmailField.isEditing ? 1.1 : 1.5)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    @IBAction func repeatButtonClick(_ sender: Any) {
        presenter.repeatButtonClick(identifierText: identifierField.text)
    }
    
    @IBAction func resetSendButtonClick(_ sender: Any) {
        guard let email = resetEmailField.text else { return }
        enableResetForm(false, full: false)
        presenter.requestResetKey(forEmail: email)
    }
    
    @IBAction func resetOpenButtonClick(_ sender: Any) {
        enableResetForm(true)
        resetOpenButton.isEnabled = false
        resetOpenButton.isHidden = true
    }
    
}

extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = nil
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(false)
        if textField == identifierField {
            repeatButtonClick(textField)
        }
        if textField == resetEmailField {
            resetSendButtonClick(textField)
        }
        return true
    }
    
}
