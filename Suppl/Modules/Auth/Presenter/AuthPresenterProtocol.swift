import Foundation

protocol AuthPresenterProtocol: class {
    func show()
    func goToRoot()
    func enableButtons()
    func disableButtons()
    func setIdentifier(_ text: String)
    func setLabel(_ text: String)
    func repeatButtonClick(identifierText: String?)
}
