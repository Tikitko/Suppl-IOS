import Foundation

protocol AuthInteractorProtocol: class {
    func tracklistUpdate()
    func startAuthCheck()
    func startAuth(keys: KeysPair?) -> Bool
    func setKeysByString(input: String?) -> Bool
    func getKeys() -> KeysPair?
    func getLocaleString(_ forKey: LocalesManager.Expression) -> String
}
