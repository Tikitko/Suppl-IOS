import Foundation
import UIKit

class TrackTableRouter: TrackTableRouterProtocol {
    
    func openPlayer(tracksIDs: [String], current: Int) {
        let playerView = PlayerRouter.setup(tracksIDs: tracksIDs, current: current)
        playerView.hidesBottomBarWhenPushed = true
        UIApplication.topViewController()?.navigationController?.pushViewController(playerView, animated: true)
        
    }
    
    static func setupForMusic(updateCallback: @escaping (_ indexPath: IndexPath) -> Void) -> TrackTableView {
        let router = TrackTableRouter()
        let interactor = TrackTableInteractorMusic(updateCallback: updateCallback)
        let presenter = TrackTablePresenter()
        let viewController = TrackTableView()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return viewController
    }
    
    
    static func setupForTracklist() -> TrackTableView {
        let router = TrackTableRouter()
        let interactor = TrackTableInteractorTracklist()
        let presenter = TrackTablePresenter()
        let viewController = TrackTableView()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return viewController
    }
}
