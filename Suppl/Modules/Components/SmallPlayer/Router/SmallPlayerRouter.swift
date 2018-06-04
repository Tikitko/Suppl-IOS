import Foundation
import UIKit

class SmallPlayerRouter: BaseRouter, SmallPlayerRouterProtocol {
    
    weak var viewController: UIViewController!
    
    static func setup() -> UIViewController {
        let router = SmallPlayerRouter()
        let interactor = SmallPlayerInteractor()
        let presenter = SmallPlayerPresenter()
        let viewController = SmallPlayerViewController()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return viewController
    }
    
    func openBigPlayer() {
        UIApplication.topViewController()?.present(PlayerRouter.setup(), animated: true, completion: nil)
    }
    
}
