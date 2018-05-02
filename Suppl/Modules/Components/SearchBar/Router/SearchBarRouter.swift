import Foundation
import UIKit

class SearchBarRouter: SearchBarRouterProtocol {
    
    weak var viewController: UISearchBar!
    
    static func setup(parentModuleNameId: String) -> UISearchBar {
        let router = SearchBarRouter()
        let interactor = SearchBarInteractor(parentModuleNameId: parentModuleNameId)
        let presenter = SearchBarPresenter()
        let viewController = SearchBarViewController()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return viewController
    }
    
}
