import Foundation

class DataSingleton {
    
    private static let _userDefaults = UserDefaults()
    public static var userDefaults: UserDefaults {
        get {
            return _userDefaults
        }
    }
    
    private static let _API = APIManager()
    public static var API: APIManager {
        get {
            return _API
        }
    }
    
    private static let ikey = "identifierKey"
    private static var _identifierKey: Int? = nil
    public static var identifierKey: Int? {
        get {
            let ikeyDef = _userDefaults.integer(forKey: ikey)
            if ikeyDef != 0 {
                _identifierKey = ikeyDef
            }
            return _identifierKey
        }
        set(value) {
            if let val = value {
                _userDefaults.set(val, forKey: ikey)
            } else {
                _userDefaults.removeObject(forKey: ikey)
            }
            _identifierKey = value
        }
    }
    
    private static let akey = "accessKey"
    private static var _accessKey: Int? = nil
    public static var accessKey: Int? {
        get {
            let akeyDef = _userDefaults.integer(forKey: akey)
            if akeyDef != 0 {
                _accessKey = akeyDef
            }
            return _accessKey
        }
        set(value) {
            if let val = value {
                _userDefaults.set(val, forKey: akey)
            } else {
                _userDefaults.removeObject(forKey: akey)
            }
            _accessKey = value
        }
    }
    
}
