import Foundation

extension APISession.ResponseError {
    
    var localizeError: String {
        return LocalesManager.shared.localized(apiSessionError: self)
    }
    
}
