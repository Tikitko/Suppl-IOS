import Foundation

class BaseInteractor {
    
    func getKeys() -> KeysPair? {
        return AuthManager.s.getAuthKeys()
    }
    
    func getLocaleString(_ expression: LocalesManager.Expression) -> String {
        return LocalesManager.s.get(expression)
    }
    
    func getLocaleString(apiErrorCode code: Int) -> String {
        return LocalesManager.s.get(apiErrorCode: code)
    }
    
}
