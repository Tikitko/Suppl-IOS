import Foundation

final class UserDefaultsManager {
    
    static public let shared = UserDefaultsManager()
    private init() {}

    public let obj = UserDefaults()
    
    public func keyGet<T>(_ key: String) -> T? {
        return obj.object(forKey: key) as? T
    }
    
    public func keySet<T>(_ key: String, value: T?) {
        obj.set(value, forKey: key)
    }
    
    private let ikey = "identifierKey"
    public var identifierKey: Int? {
        get { return keyGet(ikey) }
        set(value) { keySet(ikey, value: value) }
    }
    
    private let akey = "accessKey"
    public var accessKey: Int? {
        get { return keyGet(akey) }
        set(value) { keySet(akey, value: value) }
    }
    
}
