import Foundation
import UIKit

class RootNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setNavigationBarHidden(true, animated: false)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        setNavigationBarHidden(true, animated: true)
        return super.popToRootViewController(animated: animated)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        if viewControllers.count != 1 {
            setNavigationBarHidden(false, animated: true)
        }
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let delViewControllers = super.popToViewController(viewController, animated: animated)
        if viewControllers.count == 1 {
            setNavigationBarHidden(true, animated: true)
        }
        return delViewControllers
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        let delViewController = super.popViewController(animated: animated)
        if viewControllers.count == 1 {
            setNavigationBarHidden(true, animated: true)
        }
        return delViewController
    }
}
