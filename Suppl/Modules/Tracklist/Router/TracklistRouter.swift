import Foundation
import UIKit

class TracklistRouter: TracklistRouterProtocol {
    
    weak var viewController: UIViewController!
    
    let moduleNameId: String
    init(moduleNameId: String) {
        self.moduleNameId = moduleNameId
    }
    
    func showFilter() {
        guard let viewController = viewController as? TracklistViewController else { return }
        let filterView = TrackFilterRouter.setup(parentModuleNameId: moduleNameId)
        viewController.setFilterThenPopover(filterController: filterView)
        viewController.present(filterView, animated: true, completion: nil)
    }
    
    static func setup() -> UIViewController {
        let moduleNameId = String(arc4random_uniform(1000001))
        
        let router = TracklistRouter(moduleNameId: moduleNameId)
        let interactor = TracklistInteractor()
        let presenter = TracklistPresenter()
        let table = TrackTableRouter.setup(parentModuleNameId: moduleNameId)
        let search = SearchBarRouter.setup(parentModuleNameId: moduleNameId)
        let viewController = TracklistViewController(table: table, search: search)
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return viewController
    }
    
    
}
