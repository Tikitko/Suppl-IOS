import Foundation

protocol BaseInteractorProtocol {
    func getKeys() -> KeysPair?
    func getLocaleString(_ expression: LocalesManager.Expression) -> String
    func getLocaleString(apiErrorCode code: Int) -> String
}
