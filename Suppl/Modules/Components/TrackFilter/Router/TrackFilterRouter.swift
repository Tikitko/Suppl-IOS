import Foundation
import UIKit

class TrackFilterRouter: TrackFilterRouterProtocol {
    
    weak var viewController: UIViewController!

    static func setup(parentModuleNameId: String) -> UIViewController {
        let router = TrackFilterRouter()
        let interactor = TrackFilterInteractor(parentModuleNameId: parentModuleNameId)
        let presenter = TrackFilterPresenter()
        let viewController = TrackFilterViewController()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return viewController
    }
    
}
