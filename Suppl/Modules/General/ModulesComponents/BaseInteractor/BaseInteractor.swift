import Foundation

class BaseInteractor {

    func getLocaleString(_ expression: LocalesManager.Expression) -> String {
        return LocalesManager.shared.get(expression)
    }
    
    func getLocaleStrings(_ expressions: [LocalesManager.Expression]) -> [LocalesManager.Expression: String] {
        var strings: [LocalesManager.Expression: String] = [:]
        for expression in expressions {
            strings[expression] = getLocaleString(expression)
        }
        return strings
    }
    
    func getLocaleString(apiErrorCode code: Int) -> String {
        return LocalesManager.shared.get(apiErrorCode: code)
    }
    
}
