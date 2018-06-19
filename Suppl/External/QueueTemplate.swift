import Foundation

final class QueueTemplate {
    
    public static func continueAfter(_ continueAfter: Double, timeOutCallback: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + continueAfter, execute: timeOutCallback)
    }
    
}
