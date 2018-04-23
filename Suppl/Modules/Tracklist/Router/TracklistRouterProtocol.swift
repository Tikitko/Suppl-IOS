import Foundation

protocol TracklistRouterProtocol: class {
    func showFilter(sender: Any, timeValue: Float, titleValue: Bool, performerValue: Bool, timeCallback: ((inout Float) -> Void)?, titleCallback: ((inout Bool) -> Void)?, performerCallback: ((inout Bool) -> Void)?)
}
