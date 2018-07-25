import Foundation
import SwiftTheme
import UIKit

final class ThemeMainManager {
    
    static public let shared = ThemeMainManager()
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(set), name: .themeSettingChanged, object: nil)
    }
    
    public enum Color: String {
        case first
        case second
        case third
    }
    
    @objc public func set() {
        ThemeManager.setTheme(plistName: AppStaticData.themesList[SettingsManager.shared.theme.value], path: .mainBundle)
    }
    
    public func getColorHash(_ themeColor: Color) -> String {
        return ThemeManager.color(for: themeColor.rawValue + "Color")!.hexString(true)
    }
    
    public func pickerWithAttributes(_ attributes: [[NSAttributedStringKey: AnyObject]]) -> ThemeDictionaryPicker {
        return ThemeDictionaryPicker.pickerWithAttributes(attributes)
    }
    
}
