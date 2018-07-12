import Foundation
import SwiftTheme

final class SettingsManager {
    
    static public let shared = SettingsManager()
    private init() {}
    
    private let roundIconsName = "roundIcons"
    private let roundIconsDefault = false
    public var roundIcons: Bool! {
        get {
            guard let returnValue: Bool = UserDefaultsManager.shared.keyGet(roundIconsName) else {
                UserDefaultsManager.shared.keySet(roundIconsName, value: roundIconsDefault)
                return roundIconsDefault
            }
            return returnValue
        }
        set(value) {
            UserDefaultsManager.shared.keySet(roundIconsName, value: value)
            NotificationCenter.default.post(name: .roundIconsSettingChanged, object: nil, userInfo: nil)
        }
    }
    
    private let loadImagesName = "loadImages"
    private let loadImagesDefault = true
    public var loadImages: Bool! {
        get {
            guard let returnValue: Bool = UserDefaultsManager.shared.keyGet(loadImagesName) else {
                UserDefaultsManager.shared.keySet(loadImagesName, value: loadImagesDefault)
                return loadImagesDefault
            }
            return returnValue
        }
        set(value) {
            UserDefaultsManager.shared.keySet(loadImagesName, value: value)
            NotificationCenter.default.post(name: .loadImagesSettingChanged, object: nil, userInfo: nil)
        }
    }
    
    private let autoNextTrackName = "autoNextTrack"
    private let autoNextTrackDefault = true
    public var autoNextTrack: Bool! {
        get {
            guard let returnValue: Bool = UserDefaultsManager.shared.keyGet(autoNextTrackName) else {
                UserDefaultsManager.shared.keySet(autoNextTrackName, value: autoNextTrackDefault)
                return autoNextTrackDefault
            }
            return returnValue
        }
        set(value) {
            UserDefaultsManager.shared.keySet(autoNextTrackName, value: value)
            NotificationCenter.default.post(name: .autoNextTrackSettingChanged, object: nil, userInfo: nil)
        }
    }
    
    private let themeName = "theme"
    private let themeDefault: Int = 0
    public var theme: Int! {
        get {
            guard let returnValue: Int = UserDefaultsManager.shared.keyGet(themeName) else {
                UserDefaultsManager.shared.keySet(themeName, value: themeDefault)
                return themeDefault
            }
            return returnValue
        }
        set(value) {
            UserDefaultsManager.shared.keySet(themeName, value: value)
            NotificationCenter.default.post(name: .themeSettingChanged, object: nil, userInfo: nil)
            setTheme()
        }
    }
    
    private let smallCellName = "smallCell"
    private let smallCellDefault: Bool = false
    public var smallCell: Bool! {
        get {
            guard let returnValue: Bool = UserDefaultsManager.shared.keyGet(smallCellName) else {
                UserDefaultsManager.shared.keySet(smallCellName, value: smallCellDefault)
                return smallCellDefault
            }
            return returnValue
        }
        set(value) {
            UserDefaultsManager.shared.keySet(smallCellName, value: value)
            NotificationCenter.default.post(name: .smallCellSettingChanged, object: nil, userInfo: nil)
        }
    }
    
    public func setTheme() {
        ThemeManager.setTheme(plistName: AppStaticData.themesList[theme], path: .mainBundle)
    }
    
}

extension Notification.Name {
    static let roundIconsSettingChanged = Notification.Name("RoundIconsSettingChanged")
    static let loadImagesSettingChanged = Notification.Name("LoadImagesSettingChanged")
    static let autoNextTrackSettingChanged = Notification.Name("AutoNextTrackSettingChanged")
    static let themeSettingChanged = Notification.Name("ThemeSettingChanged")
    static let smallCellSettingChanged = Notification.Name("SmallCellSettingChanged")
}

