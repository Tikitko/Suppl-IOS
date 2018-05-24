import Foundation
import UIKit
import Toast_Swift

final class ToastTemplate {
    
    static func baseTop(title: String, body: String, duration: Double = 2.0) {
        UIApplication.topViewController()?.view.makeToast(body, duration: 2.0, position: .top, title: title)
    }
    
}
