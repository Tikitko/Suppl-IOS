import Foundation

extension Notification {
    
    func value<T>(_ type: T.Type = T.self) -> T? {
        return userInfo?["value"] as? T
    }
    
}
