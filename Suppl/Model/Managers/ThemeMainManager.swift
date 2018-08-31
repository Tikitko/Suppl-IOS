import Foundation
import SwiftTheme
import UIKit

final class ThemeMainManager {
    
    static public let shared = ThemeMainManager()
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(set), name: .themeSettingChanged, object: nil)
    }
    
    @objc public func set() {
        ThemeManager.setTheme(plistName: AppStaticData.themesList[SettingsManager.shared.theme.value], path: .mainBundle)
    }
    
}
