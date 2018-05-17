import Foundation
import UIKit

class MainRouter: MainRouterProtocol {
    
    weak var viewController: UIViewController!
    
    let moduleNameId: String
    init(moduleNameId: String) {
        self.moduleNameId = moduleNameId
    }
    
    static func setup() -> UIViewController {
        let moduleNameId = String(arc4random_uniform(1000001))
        
        let router = MainRouter(moduleNameId: moduleNameId)
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let table = TrackTableRouter.setup(parentModuleNameId: moduleNameId)
        let search = SearchBarRouter.setup(parentModuleNameId: moduleNameId)
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
