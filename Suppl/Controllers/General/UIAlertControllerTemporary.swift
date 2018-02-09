import Foundation
import UIKit

extension UIAlertController {
    public static func temporary(lifetime sec: Int, animated: Bool, title: String?, message: String?, preferredStyle: UIAlertControllerStyle) {
        let alertController = self.init(title: title, message: message, preferredStyle: preferredStyle)
        UIApplication.topViewController()?.present(alertController, animated: animated) {
            Timer.scheduledTimer(withTimeInterval: TimeInterval(sec), repeats: false) { timer in
                alertController.dismiss(animated: animated)
            }
        }
    }
}
