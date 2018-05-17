import Foundation
import UIKit

class TrackTableRouter: TrackTableRouterProtocol {
    
    weak var viewController: UITableViewController!
    
    static func setup(parentModuleNameId: String) -> UITableViewController {
        let router = TrackTableRouter()
        let interactor = TrackTableInteractor(parentModuleNameId: parentModuleNameId)
        let presenter = TrackTablePresenter()
        let viewController = TrackTableViewController()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return viewController
    }
    
}
