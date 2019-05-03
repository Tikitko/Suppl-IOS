import Foundation
import UIKit

class SmallPlayerRouter: Router, SmallPlayerRouterProtocol {
    
    weak var viewController: UIViewController!
    
    static func setup() -> UIViewController {
        let router = SmallPlayerRouter()
        let interactor = SmallPlayerInteractor()
        let presenter = SmallPlayerPresenter()
        let table = TrackTableRouter.setup(parentModuleNameId: router.moduleNameId)
        let viewController = SmallPlayerViewController(table: table)
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return viewController
    }
    
    static func setup(parentRootTabBarController: RootTabBarController) -> UIViewController {
        let player = SmallPlayerRouter.setup() as! SmallPlayerViewController
        player.parentRootTabBarController = parentRootTabBarController
        player.setInParent()
        return player
    }
    
}
