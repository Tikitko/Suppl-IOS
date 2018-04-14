import Foundation
import UIKit

protocol AuthViewControllerProtocol {
    func setTheme()
    
    func setLabel(_ text: String)
    
    func setIdentifier(_ text: String)
    
    func enableButtons()
    
    func disableButtons()
    
    func keyboardWillShow(sender: NSNotification)
    
    func keyboardWillHide(sender: NSNotification)
}
