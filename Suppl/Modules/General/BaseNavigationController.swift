import Foundation
import UIKit

final class BaseNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        setNavigationBarHidden(true, animated: false)
    }
    
    func setTheme() {
        navigationBar.theme_barTintColor = "secondColor"
        navigationBar.theme_tintColor = ["#FFF"]
        navigationBar.theme_titleTextAttributes = ThemeMainManager.shared.pickerWithAttributes(
            [[NSAttributedStringKey.foregroundColor: UIColor.white]]
        )
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        setNavigationBarHidden(true, animated: animated)
        return super.popToRootViewController(animated: animated)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        if viewControllers.count != 1 {
            setNavigationBarHidden(false, animated: animated)
        }
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let delViewControllers = super.popToViewController(viewController, animated: animated)
        if viewControllers.count == 1 {
            setNavigationBarHidden(true, animated: animated)
        }
        return delViewControllers
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        let delViewController = super.popViewController(animated: animated)
        if viewControllers.count == 1 {
            setNavigationBarHidden(true, animated: animated)
        }
        return delViewController
    }
    
}
