import Foundation

protocol AuthPresenterProtocolInteractor: class {
    func setIdentifier(_ string: String)
    func setAuthStarted(isReg: Bool)
    func setAuthResult(_ error: String?, blockOnError: Bool)
    func setAuthResult(_ expression: LocalesManager.Expression, blockOnError: Bool)
    func setRequestResetResult(_ errorId: Int?)
    func setAuthResult(apiErrorCode code: Int)
    func coreDataLoaded()
}
