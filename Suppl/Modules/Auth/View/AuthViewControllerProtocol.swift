import Foundation
import UIKit

protocol AuthViewControllerProtocol: class {
    func setTheme()
    func enableResetForm(_ enabled: Bool, full: Bool)
    func setLabel(_ text: String)
    func setIdentifier(_ text: String)
    func showToast(_ text: String)
    func enableButtons()
    func disableButtons()
}
