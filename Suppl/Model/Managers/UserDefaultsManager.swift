import Foundation

class UserDefaultsManager {
    
    private(set) static var obj = UserDefaults()
    
    public static func keyGet<T>(_ key: String) -> T? {
        let value = obj.object(forKey: key)
        guard let returnValue = value as? T else { return nil }
        return returnValue
    }
    
    public static func keySet<T>(_ key: String, value: T?) {
        if let value = value {
            obj.set(value, forKey: key)
            return
        }
        obj.removeObject(forKey: key)
    }
    
    
    private static let ikey = "identifierKey"
    public static var identifierKey: Int? {
        get {
            return keyGet(ikey)
        }
        set(value) {
            keySet(ikey, value: value)
        }
    }
    
    private static let akey = "accessKey"
    public static var accessKey: Int? {
        get {
            return keyGet(akey)
        }
        set(value) {
            keySet(akey, value: value)
        }
    }
    
}
