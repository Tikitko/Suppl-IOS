import Foundation

protocol AuthInteractorProtocol: class, BaseInteractorProtocol {
    func requestIdentifierString()
    func startAuthCheck()
    func startAuth(fromString input: String?, onlyInfo: Bool)
    func loadCoreData()
}
