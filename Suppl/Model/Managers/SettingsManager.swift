import Foundation

final class SettingsManager {
    
    static public let shared = SettingsManager()
    private init() {}
    
    final class Setting<T> {
        public let name: String
        public let `default`: T
        public var notificationName: Notification.Name {
            return .init("\(name)SettingChanged")
        }
        public var value: T! {
            get {
                guard let returnValue: T = UserDefaultsManager.shared.keyGet(name) else {
                    UserDefaultsManager.shared.keySet(name, value: `default`)
                    return `default`
                }
                return returnValue
            }
            set(value) {
                let newValue = value ?? `default`
                UserDefaultsManager.shared.keySet(name, value: newValue)
                NotificationCenter.default.post(name: notificationName, object: self, userInfo: ["value": newValue])
            }
        }
        fileprivate init(_ name: String, default: T) {
            self.name = name
            self.default = `default`
        }
        @discardableResult
        public func addObserver(queue: OperationQueue? = nil, notificationCenter: NotificationCenter = .default, using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
            return notificationCenter.addObserver(forName: notificationName, object: self, queue: queue, using: block)
        }
        public func addObserver(_ observer: Any, selector aSelector: Selector, notificationCenter: NotificationCenter = .default) {
            notificationCenter.addObserver(observer, selector: aSelector, name: notificationName, object: self)
        }
        public func removeObserver(_ observer: Any, notificationCenter: NotificationCenter = .default) {
            notificationCenter.removeObserver(observer, name: notificationName, object: self)
        }
    }
    
    let roundIcons = Setting<Bool>("RoundIcons", default: false)
    let loadImages = Setting<Bool>("LoadImages", default: true)
    let autoNextTrack = Setting<Bool>("AutoNextTrack", default: true)
    let smallCell = Setting<Bool>("SmallCell", default: false)
    let hideLogo = Setting<Bool>("HideLogo", default: true)
    let theme = Setting<Int>("Theme", default: 0)
    
}

