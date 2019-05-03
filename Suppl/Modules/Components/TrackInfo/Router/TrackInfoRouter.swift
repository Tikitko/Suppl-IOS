import Foundation
import UIKit

class TrackInfoRouter: Router, TrackInfoRouterProtocol {
    
    private struct Constants {
        static let nibNameTrackInfoBig = "TrackInfoViewController"
        static let nibNameTrackInfoSmall = "TrackInfoViewController_small"
    }
    
    weak var viewController: UIViewController!
    
    static func setup(small: Bool = false) -> (moduleNameId: String, controller: UIViewController) {
        let router = TrackInfoRouter()
        let interactor = TrackInfoInteractor()
        let presenter = TrackInfoPresenter()
        let viewController = TrackInfoViewController(nibName: small ? Constants.nibNameTrackInfoSmall : Constants.nibNameTrackInfoBig, bundle: nil)
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return (router.moduleNameId, viewController)
    }
    
}
