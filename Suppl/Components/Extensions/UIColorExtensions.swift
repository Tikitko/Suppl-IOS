import Foundation
import SwiftTheme

extension UIColor {
    
    enum Theme {
        case first
        case second
        case third
        
        var string: String {
            return String(describing: self) + "Color"
        }
        var picker: ThemeColorPicker {
            return ThemeColorPicker(keyPath: string)
        }
        var color: UIColor {
            return ThemeManager.color(for: string)!
        }
        var hash: String {
            return color.hexString(true)
        }
        static var widthColorHash: String {
            return UIColor.white.hexString(true)
        }
    }
    
}
