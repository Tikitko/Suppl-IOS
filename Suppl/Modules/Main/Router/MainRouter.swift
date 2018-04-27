import Foundation
import UIKit

class MainRouter: MainRouterProtocol {
    
    weak var viewController: UIViewController!
    
    static func setup() -> UIViewController {
        let router = MainRouter()
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let table = TrackTableRouter.setupForMusic(updateCallback: interactor.loadMoreCallback(_:), reloadData: &interactor.reloadData)
        let search = SearchBarRouter.setup()
        let viewController = MainViewController(table: table, search: search)
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return viewController
    }
    
}
