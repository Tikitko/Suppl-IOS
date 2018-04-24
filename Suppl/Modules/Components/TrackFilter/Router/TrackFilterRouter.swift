import Foundation
import UIKit

class TrackFilterRouter: TrackFilterRouterProtocol {
    
    weak var viewController: UIViewController!

    static func setup(defaultValues: FilterDefaultValues, name: String) -> UIViewController {
        let router = TrackFilterRouter()
        let interactor = TrackFilterInteractor(name: name)
        let presenter = TrackFilterPresenter()
        let viewController = TrackFilterViewController()
        viewController.defaultValues = defaultValues
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return viewController
    }
    
}
