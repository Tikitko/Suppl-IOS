import Foundation

class BaseInteractor {
    
    func getKeys() -> KeysPair? {
        return AuthManager.s.getAuthKeys()
    }
    
    func getLocaleString(_ forKey: LocalesManager.Expression) -> String {
        return LocalesManager.s.get(forKey)
    }
    
}
