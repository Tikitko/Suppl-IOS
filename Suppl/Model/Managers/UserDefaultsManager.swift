import Foundation

final class UserDefaultsManager {
    
    private struct Constants {
        static let ikey = "identifierKey"
        static let akey = "accessKey"
    }
    
    static public let shared = UserDefaultsManager()
    private init() {}
    
    public let obj = UserDefaults()
    
    public func keyGet<T>(_ key: String, _ type: T.Type = T.self) -> T? {
        return obj.object(forKey: key) as? T
    }
    
    public func keySet<T>(_ key: String, value: T?) {
        obj.set(value, forKey: key)
    }
    
    public var identifierKey: Int? {
        get { return keyGet(Constants.ikey) }
        set(value) { keySet(Constants.ikey, value: value) }
    }
    
    public var accessKey: Int? {
        get { return keyGet(Constants.akey) }
        set(value) { keySet(Constants.akey, value: value) }
    }
    
}
