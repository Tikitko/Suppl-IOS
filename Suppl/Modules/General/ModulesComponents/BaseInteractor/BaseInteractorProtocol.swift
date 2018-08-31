import Foundation

protocol BaseInteractorProtocol {
    func getLocaleString(_ expression: LocalesManager.Expression) -> String
    func getLocaleStrings(_ expressions: [LocalesManager.Expression]) -> [LocalesManager.Expression: String]
    func getLocaleString(apiErrorCode code: Int) -> String
}
