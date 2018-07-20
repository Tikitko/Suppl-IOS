import Foundation

protocol BaseInteractorProtocol {
    func getLocaleString(_ expression: LocalesManager.Expression) -> String
    func getLocaleString(apiErrorCode code: Int) -> String
    func getThemeColorHash(_ themeColor: ThemeMainManager.Color) -> String
}
