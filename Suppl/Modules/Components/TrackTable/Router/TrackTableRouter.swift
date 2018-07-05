import Foundation
import UIKit

class TrackTableRouter: BaseRouter, TrackTableRouterProtocol {
    
    weak var viewController: UITableViewController!
    
    static func setup(parentModuleNameId: String) -> UITableViewController {
        let router = TrackTableRouter()
        let interactor = TrackTableInteractor(parentModuleNameId: parentModuleNameId)
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
    
    func showToastOnTop(title: String, body: String, duration: Double = 2.0) {
        UIApplication.topViewController()?.view.makeToast(body, duration: 2.0, position: .top, title: title)
    }
    
}
