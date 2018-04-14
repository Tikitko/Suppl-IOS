import Foundation
import UIKit

class AuthRouter: AuthRouterProtocol {
    
    weak var viewController: UIViewController!
    
    func goToRootTabBar() {
        viewController.present(RootTabBarController(), animated: true)
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
