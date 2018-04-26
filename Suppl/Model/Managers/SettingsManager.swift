import Foundation
import SwiftTheme

final class SettingsManager {
    
    static public let s = SettingsManager()
    private init() {
        setTheme()
    }
    
    private let roundIconsName = "roundIcons"
    private let roundIconsDefault = false
    public var roundIcons: Bool? {
        get {
            guard let value: Bool? = UserDefaultsManager.s.keyGet(roundIconsName), let returnValue = value else {
                UserDefaultsManager.s.keySet(roundIconsName, value: roundIconsDefault)
                return roundIconsDefault
            }
            return returnValue
        }
        set(value) {
            UserDefaultsManager.s.keySet(roundIconsName, value: value)
        }
    }
    
    private let loadImagesName = "loadImages"
    private let loadImagesDefault = true
    public var loadImages: Bool? {
        get {
            guard let value: Bool? = UserDefaultsManager.s.keyGet(loadImagesName), let returnValue = value else {
                UserDefaultsManager.s.keySet(loadImagesName, value: loadImagesDefault)
                return loadImagesDefault
            }
            return returnValue
        }
        set(value) {
            UserDefaultsManager.s.keySet(loadImagesName, value: value)
        }
    }
    
    private let autoNextTrackName = "autoNextTrack"
    private let autoNextTrackDefault = true
    public var autoNextTrack: Bool? {
        get {
            guard let value: Bool? = UserDefaultsManager.s.keyGet(autoNextTrackName), let returnValue = value else {
                UserDefaultsManager.s.keySet(autoNextTrackName, value: autoNextTrackDefault)
                return autoNextTrackDefault
            }
            return returnValue
        }
        set(value) {
            UserDefaultsManager.s.keySet(autoNextTrackName, value: value)
        }
    }
    
    private let themeName = "theme"
    private let themeDefault: Int = 0
    public var theme: Int? {
        get {
            guard let value: Int? = UserDefaultsManager.s.keyGet(themeName), let returnValue = value else {
                UserDefaultsManager.s.keySet(themeName, value: themeDefault)
                return themeDefault
            }
            return returnValue
        }
        set(value) {
            UserDefaultsManager.s.keySet(themeName, value: value)
            setTheme()
        }
    }
    
    private func setTheme() {
        ThemeManager.setTheme(plistName: AppStaticData.themesList[theme!], path: .mainBundle)
    }
}
