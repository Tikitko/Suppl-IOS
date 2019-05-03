import UIKit

final class SmallPlayerAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private weak var smallPlayerViewController: SmallPlayerViewController!
    
    private let forPresent: Bool
    
    init(_ smallPlayerViewController: SmallPlayerViewController, forPresent: Bool) {
        self.forPresent = forPresent
        super.init()
        self.smallPlayerViewController = smallPlayerViewController
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        forPresent ? present(using: transitionContext) : dismiss(using: transitionContext)
    }
    
    private func stopTable() {
        let table = smallPlayerViewController.tracksTableModule.tableView
        table?.setContentOffset(table!.contentOffset, animated: false)
    }
    
    func present(using transitionContext: UIViewControllerContextTransitioning) {
        let tabBar = smallPlayerViewController.parentRootTabBarController.tabBar
        guard let _ = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to),
              let tabBarSnapshot = tabBar.snapshotView(afterScreenUpdates: true)
            else { return }
        
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        tabBarSnapshot.frame = tabBar.frame
        containerView.addSubview(toVC.view)
        containerView.addSubview(tabBarSnapshot)
        
        stopTable()
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                    self.smallPlayerViewController.setPlayerShow(type: .opened)
                    tabBarSnapshot.alpha = tabBar.alpha
                }
            },
            completion: { _ in
                if transitionContext.transitionWasCancelled {
                    self.smallPlayerViewController.setPlayerShow(type: .partOpened)
                    tabBarSnapshot.alpha = tabBar.alpha
                } else {
                    tabBarSnapshot.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
    
    func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
        let tabBar = smallPlayerViewController.parentRootTabBarController.tabBar
        guard let _ = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to)
            else { return }
        
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        
        tabBar.alpha = 1
        let tabBarSnapshot: UIView = tabBar.snapshotView(afterScreenUpdates: true)!
        tabBar.alpha = 0
        tabBarSnapshot.alpha = 0
        tabBarSnapshot.frame = tabBar.frame
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, at: 0)
        containerView.addSubview(tabBarSnapshot)
        
        let duration = transitionDuration(using: transitionContext)
        
        stopTable()
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                    self.smallPlayerViewController.setPlayerShow(type: .partOpened, rootSelf: true)
                    tabBarSnapshot.alpha = tabBar.alpha
                }
            },
            completion: { _ in
                tabBarSnapshot.removeFromSuperview()
                if transitionContext.transitionWasCancelled {
                    self.smallPlayerViewController.setPlayerShow(type: .opened)
                    tabBarSnapshot.alpha = tabBar.alpha
                } else {
                    toVC.view.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
    
}
