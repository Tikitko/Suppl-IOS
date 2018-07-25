import Foundation

final class QueueTemplate {
    
    public static func continueAfter(_ continueAfter: Double, timeOutCallback: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + continueAfter, execute: timeOutCallback)
    }
    
}
