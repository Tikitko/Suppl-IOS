import Foundation

class UserDefaultsManager {
    
    private(set) static var obj = UserDefaults()
    
    private static let ikey = "identifierKey"
    private static var _identifierKey: Int? = nil
    public static var identifierKey: Int? {
        get {
            let ikeyDef = obj.integer(forKey: ikey)
            if ikeyDef != 0 {
                _identifierKey = ikeyDef
            }
            return _identifierKey
        }
        set(value) {
            if let val = value {
                obj.set(val, forKey: ikey)
            } else {
                obj.removeObject(forKey: ikey)
            }
            _identifierKey = value
        }
    }
    
    private static let akey = "accessKey"
    private static var _accessKey: Int? = nil
    public static var accessKey: Int? {
        get {
            let akeyDef = obj.integer(forKey: akey)
            if akeyDef != 0 {
                _accessKey = akeyDef
            }
            return _accessKey
        }
        set(value) {
            if let val = value {
                obj.set(val, forKey: akey)
            } else {
                obj.removeObject(forKey: akey)
            }
            _accessKey = value
        }
    }
    
}
