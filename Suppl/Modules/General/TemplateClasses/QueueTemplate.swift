import Foundation

final class QueueTemplate {
    static func continueAfter(_ continueAfter: Double, timeOutCallback: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + continueAfter, execute: timeOutCallback)
    }
}
