import Foundation
import UIKit

class TracklistRouter: TracklistRouterProtocol {
    
    let moduleNameId: String
    init(moduleNameId: String) {
        self.moduleNameId = moduleNameId
    }
    
    weak var viewController: UIViewController!
    weak var presenter: TracklistPresenter!
    
    func showFilter() {
        let filterView = TrackFilterRouter.setup(parentModuleNameId: moduleNameId)
        presenter.setFilterThenPopover(filterController: filterView)
        viewController.present(filterView, animated: true, completion: nil)
    }
    
    static func setup() -> UIViewController {
        let moduleNameId = String(arc4random_uniform(1000001))
        
        let router = TracklistRouter(moduleNameId: moduleNameId)
        let interactor = TracklistInteractor()
        let presenter = TracklistPresenter()
        let table = TrackTableRouter.setupForTracklist(parentModuleNameId: moduleNameId)
        let search = SearchBarRouter.setup(parentModuleNameId: moduleNameId)
        let viewController = TracklistViewController(table: table, search: search)
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        router.presenter = presenter
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return viewController
    }
    
    
}
