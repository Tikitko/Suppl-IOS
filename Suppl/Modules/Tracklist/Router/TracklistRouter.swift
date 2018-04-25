import Foundation
import UIKit

class TracklistRouter: TracklistRouterProtocol {
    
    weak var viewController: UIViewController!
    
    func showFilter(sender: Any, config: FilterConfig) {
        guard let btn = sender as? UIButton else { return }
        let filterView = TrackFilterRouter.setup(config: config)
        filterView.preferredContentSize = CGSize(width: 400, height: 180)
        filterView.modalPresentationStyle = .popover
        let pop = filterView.popoverPresentationController
        pop?.delegate = viewController as? UIPopoverPresentationControllerDelegate
        pop?.sourceView = btn
        pop?.sourceRect = btn.bounds
        viewController.present(filterView, animated: true, completion: nil)
    }
    
    static func setup() -> UIViewController {
        let router = TracklistRouter()
        let interactor = TracklistInteractor()
        let presenter = TracklistPresenter()
        let table = TrackTableRouter.setupForTracklist(reloadData: &interactor.reloadData)
        let viewController = TracklistViewController(table: table)
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return viewController
    }
    
    
}
