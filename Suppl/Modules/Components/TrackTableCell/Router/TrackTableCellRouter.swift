import Foundation
import UIKit

class TrackTableCellRouter: BaseRouter, TrackTableCellRouterProtocol {
    
    weak var viewController: UITableViewCell!
    
    static func setup() -> (moduleNameId: String, cell: UITableViewCell) {
        let router = TrackTableCellRouter()
        let interactor = TrackTableCellInteractor()
        let presenter = TrackTableCellPresenter()
        let viewController = TrackTableCellViewController()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return (router.moduleNameId, viewController)
    }
    
}
