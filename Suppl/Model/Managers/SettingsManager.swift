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
            setTheme()
        }
    }
    
    private static func setTheme() {
        ThemeManager.setTheme(plistName: AppStaticData.themesList[theme!], path: .mainBundle)
    }
}
