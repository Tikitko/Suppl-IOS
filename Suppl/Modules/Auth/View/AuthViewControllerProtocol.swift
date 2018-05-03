import Foundation
import UIKit

protocol AuthViewControllerProtocol: class {
    func setTheme()
    func setLabel(_ text: String)
    func setIdentifier(_ text: String)
    func enableButtons()
    func disableButtons()
}
