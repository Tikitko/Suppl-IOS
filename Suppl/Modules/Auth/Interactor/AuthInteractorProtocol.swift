import Foundation

protocol AuthInteractorProtocol: class, BaseInteractorProtocol {
    func startAuthCheck()
    func startAuth(fromString input: String?, onlyInfo: Bool)
}
