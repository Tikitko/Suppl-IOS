import Foundation
import UIKit

class TrackFilterRouter: TrackFilterRouterProtocol {
    
    weak var viewController: UIViewController!

    static func setup(config: FilterConfig) -> UIViewController {
        let router = TrackFilterRouter()
        let presenter = TrackFilterPresenter()
        let viewController = TrackFilterViewController()
        viewController.config = config
        
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        return viewController
    }
    
}
