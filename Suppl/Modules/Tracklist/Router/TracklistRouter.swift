import Foundation
import UIKit

class TracklistRouter: Router, TracklistRouterProtocol {
    
    weak var viewController: UIViewController!
    
    func showFilter() {
        guard let viewController = viewController as? TracklistViewController else { return }
        let filterView = TrackFilterRouter.setup(parentModuleNameId: moduleNameId)
        viewController.setFilterThenPopover(filterController: filterView)
        viewController.present(filterView, animated: true, completion: nil)
    }
    
    static func setup() -> UIViewController {
        let router = TracklistRouter()
        let interactor = TracklistInteractor()
        let presenter = TracklistPresenter()
        let table = TrackTableRouter.setup(parentModuleNameId: router.moduleNameId)
        let search = SearchBarRouter.setup(parentModuleNameId: router.moduleNameId)
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
