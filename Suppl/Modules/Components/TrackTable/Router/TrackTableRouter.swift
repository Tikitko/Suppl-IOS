import Foundation
import UIKit

class TrackTableRouter: TrackTableRouterProtocol {
    
    weak var viewController: UITableViewController!
    
    func openPlayer(tracksIDs: [String], current: Int) {
        let playerView = PlayerRouter.setup(tracksIDs: tracksIDs, current: current)
        playerView.hidesBottomBarWhenPushed = true
        UIApplication.topViewController()?.navigationController?.pushViewController(playerView, animated: true)
    }
    
    static func setupForMusic(updateCallback: @escaping (_ indexPath: IndexPath) -> Void, reloadData: inout ((_ tracks: [AudioData], _ foundTracks: [AudioData]?) -> Void)?) -> UITableViewController {
        let router = TrackTableRouter()
        let interactor = TrackTableInteractorMusic(updateCallback: updateCallback)
        let presenter = TrackTablePresenter()
        let viewController = TrackTableViewController()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        reloadData = presenter.updateTracks(tracks:foundTracks:)
        
        return viewController
    }
    
    
    static func setupForTracklist(reloadData: inout ((_ tracks: [AudioData], _ foundTracks: [AudioData]?) -> Void)?) -> UITableViewController {
        let router = TrackTableRouter()
        let interactor = TrackTableInteractorTracklist()
        let presenter = TrackTablePresenter()
        let viewController = TrackTableViewController()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        reloadData = presenter.updateTracks(tracks:foundTracks:)
        
        return viewController
    }
}
