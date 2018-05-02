import Foundation
import UIKit

class TrackTableRouter: TrackTableRouterProtocol {
    
    weak var viewController: UITableViewController!
    
    func openPlayer(tracksIDs: [String], current: Int) {
        let playerView = PlayerRouter.setup(tracksIDs: tracksIDs, current: current)
        playerView.hidesBottomBarWhenPushed = true
        UIApplication.topViewController()?.navigationController?.pushViewController(playerView, animated: true)
    }
    
    static func setupForMusic(parentModuleNameId: String) -> UITableViewController {
        let router = TrackTableRouter()
        let interactor = TrackTableInteractorMusic(parentModuleNameId: parentModuleNameId)
        let presenter = TrackTablePresenter()
        let viewController = TrackTableViewController()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return viewController
    }
    
    
    static func setupForTracklist(parentModuleNameId: String) -> UITableViewController {
        let router = TrackTableRouter()
        let interactor = TrackTableInteractorTracklist(parentModuleNameId: parentModuleNameId)
        let presenter = TrackTablePresenter()
        let viewController = TrackTableViewController()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return viewController
    }
}
