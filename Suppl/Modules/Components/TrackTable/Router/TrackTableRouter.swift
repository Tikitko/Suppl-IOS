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
    
    func createCell(small: Bool) -> (moduleNameId: String, controller: UIViewController) {
        return TrackInfoRouter.setup(small: small)
    }
    
    func showToastOnTop(title: String, body: String, duration: Double = 2.0) {
        UIApplication.topViewController()?.view.makeToast(body, duration: duration, position: .top, title: title)
    }
    
}
