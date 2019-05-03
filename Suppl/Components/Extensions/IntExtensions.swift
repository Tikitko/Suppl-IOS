import Foundation

extension Int {
    
    var localizeAPIErrorCode: String {
        return LocalesManager.shared.localized(apiErrorCode: self)
    }
    
}
