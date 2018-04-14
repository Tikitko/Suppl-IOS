import Foundation
import UIKit

class AuthRouter: AuthRouterProtocol {
    
    var viewController: AuthViewController!
    
    func goToRootTabBar() {
        viewController.present(RootTabBarController(), animated: true)
    }
    
    static func setupInWindow() -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = self.setup(noAuth: false)
        window.makeKeyAndVisible()
        return window
    }
    
    static func setup(noAuth noAuthOnShow: Bool) -> UIViewController {
        let router = AuthRouter()
        let interactor = AuthInteractor()
        interactor.noAuthOnShow = noAuthOnShow
        let presenter = AuthPresenter()
        let viewController = AuthViewController()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return viewController
    }
}
