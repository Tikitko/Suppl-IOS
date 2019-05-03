import Foundation

protocol AuthInteractorProtocol: class {
    func requestIdentifierString()
    func startAuthCheck()
    func startAuth(fromString input: String?, resetKey: String?, onlyInfo: Bool)
    func loadCoreData()
    func requestResetKey(forEmail email: String)
}
