import Foundation

protocol AuthPresenterProtocol: class {
    func setLoadLabel()
    func firstStartAuth()
    func setAuthStarted(isReg: Bool)
    func setAuthResult(_ error: String?)
    func setAuthResult(_ expression: LocalesManager.Expression)
    func repeatButtonClick(identifierText: String?)
}
