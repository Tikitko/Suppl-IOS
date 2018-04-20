import Foundation
import UIKit

class PlayerRouter: PlayerRouterProtocol {
    
    weak var viewController: UIViewController!
    
    static func setup(tracksIDs: [String], current: Int = 0) -> UIViewController {
        let router = PlayerRouter()
        let interactor = PlayerInteractor(tracksIDs: tracksIDs, current: current)
        let presenter = PlayerPresenter()
        let viewController = PlayerViewController()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return viewController
    }
}
