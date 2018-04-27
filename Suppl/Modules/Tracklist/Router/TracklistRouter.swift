import Foundation
import UIKit

class TracklistRouter: TracklistRouterProtocol {
    
    weak var viewController: UIViewController!
    weak var presenter: TracklistPresenter!
    
    func showFilter() {
        let filterView = TrackFilterRouter.setup()
        presenter.setFilterThenPopover(filterController: filterView)
        viewController.present(filterView, animated: true, completion: nil)
    }
    
    static func setup() -> UIViewController {
        let router = TracklistRouter()
        let interactor = TracklistInteractor()
        let presenter = TracklistPresenter()
        let table = TrackTableRouter.setupForTracklist()
        let search = SearchBarRouter.setup()
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
