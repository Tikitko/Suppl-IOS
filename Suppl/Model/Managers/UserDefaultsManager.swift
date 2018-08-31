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
    
    public var identifierKey: Int? {
        get { return keyGet(AppStaticData.Consts.ikey) }
        set(value) { keySet(AppStaticData.Consts.ikey, value: value) }
    }
    
    public var accessKey: Int? {
        get { return keyGet(AppStaticData.Consts.akey) }
        set(value) { keySet(AppStaticData.Consts.akey, value: value) }
    }
    
}
