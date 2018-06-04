import Foundation

protocol AuthPresenterProtocol: class {}

protocol AuthPresenterProtocolInteractor: AuthPresenterProtocol {
    func setIdentifier(_ string: String)
    func setAuthStarted(isReg: Bool)
    func setAuthResult(_ error: String?, blockOnError: Bool)
    func setAuthResult(_ expression: LocalesManager.Expression, blockOnError: Bool)
    func setAuthResult(apiErrorCode code: Int)
}

protocol AuthPresenterProtocolView: AuthPresenterProtocol {
    func setLoadLabel()
    func firstStartAuth()
    func repeatButtonClick(identifierText: String?)
}
