import Foundation
import UIKit

class TrackInfoRouter: BaseRouter, TrackInfoRouterProtocol {
    
    weak var viewController: UIViewController!
    
    static func setup(small: Bool = false) -> (moduleNameId: String, controller: UIViewController) {
        let router = TrackInfoRouter()
        let interactor = TrackInfoInteractor()
        let presenter = TrackInfoPresenter()
        let viewController = TrackInfoViewController(nibName: small ? "TrackInfoViewController_small" : "TrackInfoViewController", bundle: nil)
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return (router.moduleNameId, viewController)
    }
    
}
