import Foundation
import UIKit

class PlayerRouter: BaseRouter, PlayerRouterProtocol {
    
    weak var viewController: UIViewController!
    
    static func setup() -> UIViewController {
        let router = PlayerRouter()
        let interactor = PlayerInteractor()
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
    
    func closePlayer() {
        viewController.dismiss(animated: true, completion: nil)
    }
}
