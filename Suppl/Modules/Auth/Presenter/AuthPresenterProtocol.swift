import Foundation

protocol AuthPresenterProtocol: class {}

protocol AuthPresenterProtocolInteractor: AuthPresenterProtocol {
    func setAuthStarted(isReg: Bool)
    func setAuthResult(_ error: String?)
    func setAuthResult(_ expression: LocalesManager.Expression)
}

protocol AuthPresenterProtocolView: AuthPresenterProtocol {
    func setLoadLabel()
    func firstStartAuth()
    func repeatButtonClick(identifierText: String?)
}
