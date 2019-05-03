import UIKit

final class SmallPlayerInteractionController: UIPercentDrivenInteractiveTransition {
    
    private weak var smallPlayerViewController: SmallPlayerViewController!
    
    private let forPresent: Bool
    private(set) var interactionInProgress = false
    private var shouldCompleteTransition = false
    private var gesture: UIPanGestureRecognizer!
    private var startProgress: CGFloat?
    
    init(_ smallPlayerViewController: SmallPlayerViewController, forPresent: Bool) {
        self.forPresent = forPresent
        super.init()
        self.smallPlayerViewController = smallPlayerViewController
        let toView = forPresent ? self.smallPlayerViewController.parentRootTabBarController.view : self.smallPlayerViewController.view
        prepareGestureRecognizer(in: toView!)
    }
    
    private func prepareGestureRecognizer(in view: UIView) {
        gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    private func getProgress(gestureRecognizer: UIPanGestureRecognizer) -> CGFloat {
        let prFrame = smallPlayerViewController.parentRootTabBarController.tabBar.frame
        let tapPositionInParent = gestureRecognizer.location(in: smallPlayerViewController.view).y - prFrame.height
        var progress = 1 - CGFloat(fminf(fmaxf(Float((tapPositionInParent / prFrame.origin.y) * (!forPresent ? -1 : 1)), 0.0), 1.0))
        if gestureRecognizer.state == .began || startProgress == 1 {
            startProgress = progress
        }
        let startProgressIn = startProgress ?? 0
        let centerBack = (1 + startProgressIn) / 2
        progress = progress < centerBack ? ((progress - startProgressIn) / (centerBack - startProgressIn)) * centerBack : progress
        if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
            startProgress = nil
        }
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        return progress
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let progress = getProgress(gestureRecognizer: gestureRecognizer)
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            forPresent ? smallPlayerViewController.openFullPlayer() : smallPlayerViewController.closeFullPlayer()
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
        case .cancelled:
            interactionInProgress = false
            cancel()
        case .ended:
            interactionInProgress = false
            shouldCompleteTransition ? finish() : cancel()
        default: break
        }
    }
}

extension SmallPlayerInteractionController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let sp = smallPlayerViewController!
        return !((sp.nowShowType != .opened &&
        gestureRecognizer.view == sp.view) ||
        (sp.tracksTableModule.view.point(inside: gestureRecognizer.location(in: sp.tracksTableModule.view), with: nil) &&
        !(sp.tracksTableModule.view.alpha == 0))) &&
        (sp.nowShowType != .closed &&
        sp.view.point(inside: gestureRecognizer.location(in: sp.view), with: nil))
    }
    
}
