import Foundation

protocol AuthPresenterProtocol: class {
    func load()
    func show()
    func setAuthResult(error: String?)
    func setAuthFormVisable()
    func goToRoot()
    func repeatButtonClick(identifierText: String?)
}
