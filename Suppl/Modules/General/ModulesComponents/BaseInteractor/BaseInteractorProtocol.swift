import Foundation

protocol BaseInteractorProtocol {
    func getKeys() -> KeysPair?
    func getLocaleString(_ forKey: LocalesManager.Expression) -> String
}
