import Foundation
import UIKit
import Toast_Swift

extension UIView {
    
    public func includeInside(_ parent: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        heightAnchor.constraint(equalTo: parent.heightAnchor, multiplier: 1, constant: 0).isActive = true
        widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: 1, constant: 0).isActive = true
    }
    
    public func toast(_ message: String?, duration: TimeInterval = ToastManager.shared.duration, position: ToastPosition = ToastManager.shared.position, title: String? = nil, image: UIImage? = nil, style: ToastStyle = ToastManager.shared.style, completion: ((_ didTap: Bool) -> Void)? = nil) {
        makeToast(message, duration: duration, position: position, title: title, image: image, style: style, completion: completion)
    }
    
}
