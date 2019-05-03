import Foundation
import UIKit

class MainRouter: Router, MainRouterProtocol {
    
    weak var viewController: UIViewController!
    
    static func setup() -> UIViewController {
        let router = MainRouter()
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let table = TrackTableRouter.setup(parentModuleNameId: router.moduleNameId)
        let search = SearchBarRouter.setup(parentModuleNameId: router.moduleNameId)
        let viewController = MainViewController(table: table, search: search)
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return viewController
    }
    
}
