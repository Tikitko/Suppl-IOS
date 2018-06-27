import UIKit

class SmallPlayerInteractionController: UIPercentDrivenInteractiveTransition {
    
    private weak var smallPlayerViewController: SmallPlayerViewController!
    
    var interactionInProgress = false
    private var shouldCompleteTransition = false
    private(set) var gesture: UIPanGestureRecognizer!
    
    private let forPresent: Bool
    
    init(_ smallPlayerViewController: SmallPlayerViewController, forPresent: Bool) {
        self.forPresent = forPresent
        super.init()
        self.smallPlayerViewController = smallPlayerViewController
        prepareGestureRecognizer(in: (forPresent ? self.smallPlayerViewController.parentRootTabBarController.view : self.smallPlayerViewController.playerTitleLabelBig!))
    }
    
    private func prepareGestureRecognizer(in view: UIView) {
        gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    private func getProgress(gestureRecognizer: UIPanGestureRecognizer) -> CGFloat {
        let spaceSize = smallPlayerViewController.parentRootTabBarController.tabBar.frame.origin.y
        let tapPositionInParent = gestureRecognizer.location(in: smallPlayerViewController.view).y
        let progress = 1 - CGFloat(fminf(fmaxf(Float((tapPositionInParent / spaceSize) * (!forPresent ? -1 : 1)), 0.0), 1.0))
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
        return smallPlayerViewController.view.point(inside: gestureRecognizer.location(in: smallPlayerViewController.view), with: nil)
    }
    
}
