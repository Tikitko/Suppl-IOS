import Foundation
import SwiftTheme

class SettingsManager {
    
    public static func initialize() {
        setTheme()
    }
    
    private static let roundIconsName = "roundIcons"
    private static let roundIconsDefault = false
    public static var roundIcons: Bool? {
        get {
            guard let value: Bool? = UserDefaultsManager.keyGet(roundIconsName), let returnValue = value else {
                UserDefaultsManager.keySet(roundIconsName, value: roundIconsDefault)
                return roundIconsDefault
            }
            return returnValue
        }
        set(value) {
            UserDefaultsManager.keySet(roundIconsName, value: value)
            NotificationCenter.default.post(name: .RoundIconsSettingChanged, object: nil, userInfo: nil)
        }
    }
    
    private static let loadImagesName = "loadImages"
    private static let loadImagesDefault = true
    public static var loadImages: Bool? {
        get {
            guard let value: Bool? = UserDefaultsManager.keyGet(loadImagesName), let returnValue = value else {
                UserDefaultsManager.keySet(loadImagesName, value: loadImagesDefault)
                return loadImagesDefault
            }
            return returnValue
        }
        set(value) {
            UserDefaultsManager.keySet(loadImagesName, value: value)
            NotificationCenter.default.post(name: .LoadImagesSettingChanged, object: nil, userInfo: nil)
        }
    }
    
    private static let autoNextTrackName = "autoNextTrack"
    private static let autoNextTrackDefault = true
    public static var autoNextTrack: Bool? {
        get {
            guard let value: Bool? = UserDefaultsManager.keyGet(autoNextTrackName), let returnValue = value else {
                UserDefaultsManager.keySet(autoNextTrackName, value: autoNextTrackDefault)
                return autoNextTrackDefault
            }
            return returnValue
        }
        set(value) {
            UserDefaultsManager.keySet(autoNextTrackName, value: value)
            NotificationCenter.default.post(name: .AutoNextTrackSettingChanged, object: nil, userInfo: nil)
        }
    }
    
    private static let themeName = "theme"
    private static let themeDefault: Int = 0
    public static var theme: Int? {
        get {
            guard let value: Int? = UserDefaultsManager.keyGet(themeName), let returnValue = value else {
                UserDefaultsManager.keySet(themeName, value: themeDefault)
                return themeDefault
            }
            return returnValue
        }
        set(value) {
            UserDefaultsManager.keySet(themeName, value: value)
            NotificationCenter.default.post(name: .ThemeSettingChanged, object: nil, userInfo: nil)
            setTheme()
        }
    }
    
    private static func setTheme() {
        ThemeManager.setTheme(plistName: AppStaticData.themesList[theme!], path: .mainBundle)
    }
}

extension Notification.Name {
    static let RoundIconsSettingChanged = Notification.Name("RoundIconsSettingChanged")
    static let LoadImagesSettingChanged = Notification.Name("LoadImagesSettingChanged")
    static let AutoNextTrackSettingChanged = Notification.Name("AutoNextTrackSettingChanged")
    static let ThemeSettingChanged = Notification.Name("ThemeSettingChanged")
}

