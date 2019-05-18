import Foundation

protocol AuthPresenterProtocolInteractor: class {
    func setIdentifier(_ string: String)
    func setAuthStarted(isReg: Bool)
    func setAuthResult(_ error: String?, blockOnError: Bool)
    func setAuthResult(localizationKey: String, blockOnError: Bool)
    func setRequestResetResult(_ errorString: String?)
    func setAuthResult(errorString: String)
    func coreDataLoaded()
}
