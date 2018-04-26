import Foundation

final class UserDefaultsManager {
    
    static public let s = UserDefaultsManager()
    private init() {}

    public let obj = UserDefaults()
    
    public func keyGet<T>(_ key: String) -> T? {
        let value = obj.object(forKey: key)
        guard let returnValue = value as? T else { return nil }
        return returnValue
    }
    
    public func keySet<T>(_ key: String, value: T?) {
        if let value = value {
            obj.set(value, forKey: key)
            return
        }
        obj.removeObject(forKey: key)
    }
    
    
    private let ikey = "identifierKey"
    public var identifierKey: Int? {
        get {
            return keyGet(ikey)
        }
        set(value) {
            keySet(ikey, value: value)
        }
    }
    
    private let akey = "accessKey"
    public var accessKey: Int? {
        get {
            return keyGet(akey)
        }
        set(value) {
            keySet(akey, value: value)
        }
    }
    
}
