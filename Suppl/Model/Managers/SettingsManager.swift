import Foundation

final class SettingsManager {
    
    static public let shared = SettingsManager()
    private init() {}
    
    final class Setting<T> {
        public let name: String
        public let `default`: T
        public let notification: Notification.Name
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
                NotificationCenter.default.post(name: notification, object: nil, userInfo: ["value": newValue])
            }
        }
        fileprivate init(_ name: String, _ default: T, _ notification: Notification.Name) {
            self.name = name
            self.default = `default`
            self.notification = notification
        }
    }
    
    let roundIcons = Setting<Bool>("roundIcons", false, .roundIconsSettingChanged)
    let loadImages = Setting<Bool>("loadImages", true, .loadImagesSettingChanged)
    let autoNextTrack = Setting<Bool>("autoNextTrack", true, .autoNextTrackSettingChanged)
    let smallCell = Setting<Bool>("smallCell", false, .smallCellSettingChanged)
    let hideLogo = Setting<Bool>("hideLogo", true, .hideLogoSettingChanged)
    let theme = Setting<Int>("theme", 0, .themeSettingChanged)
    
}

extension Notification.Name {
    static let roundIconsSettingChanged = Notification.Name("RoundIconsSettingChanged")
    static let loadImagesSettingChanged = Notification.Name("LoadImagesSettingChanged")
    static let autoNextTrackSettingChanged = Notification.Name("AutoNextTrackSettingChanged")
    static let themeSettingChanged = Notification.Name("ThemeSettingChanged")
    static let smallCellSettingChanged = Notification.Name("SmallCellSettingChanged")
    static let hideLogoSettingChanged = Notification.Name("HideLogoSettingChanged")
}

