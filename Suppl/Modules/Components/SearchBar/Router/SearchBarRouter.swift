import Foundation
import UIKit

class SearchBarRouter: SearchBarRouterProtocol {
    
    weak var viewController: UISearchController!
    
    static func setup(searchCallback: @escaping (String) -> Void) -> UISearchController {
        let router = SearchBarRouter()
        let presenter = SearchBarPresenter()
        let viewController = SearchBarViewController()
        viewController.searchCallback = searchCallback
        
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        return viewController
    }
    
}
