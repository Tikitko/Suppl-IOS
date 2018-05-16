import Foundation

protocol AuthPresenterProtocol: class {
    func setLoadLabel()
    func firstStartAuth()
    func setAuthResult(_ error: String?)
    func repeatButtonClick(identifierText: String?)
}
