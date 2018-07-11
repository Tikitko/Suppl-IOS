import Foundation
import SwiftTheme

final class SettingsManager {
    
    static public let s = SettingsManager()
    private init() {}
    
    private let roundIconsName = "roundIcons"
    private let roundIconsDefault = false
    public var roundIcons: Bool? {
        get {
            guard let returnValue = UserDefaultsManager.s.keyGet(roundIconsName) as Bool? else {
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
            guard let returnValue = UserDefaultsManager.s.keyGet(loadImagesName) as Bool? else {
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
            guard let returnValue = UserDefaultsManager.s.keyGet(autoNextTrackName) as Bool? else {
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
            guard let returnValue = UserDefaultsManager.s.keyGet(themeName) as Int? else {
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
    
    public func setTheme() {
        ThemeManager.setTheme(plistName: AppStaticData.themesList[theme!], path: .mainBundle)
    }
}
