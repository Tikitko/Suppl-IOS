import Foundation
import UIKit

class TrackFilterRouter: TrackFilterRouterProtocol {
    
    weak var viewController: UIViewController!

    static func setup(timeValue: Float, titleValue: Bool, performerValue: Bool, timeCallback: ((inout Float) -> Void)?, titleCallback: ((inout Bool) -> Void)?, performerCallback: ((inout Bool) -> Void)?) -> UIViewController {
        let router = TrackFilterRouter()
        let interactor = TrackFilterInteractor()
        let presenter = TrackFilterPresenter()
        let viewController = TrackFilterViewController()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        viewController.loadViewIfNeeded()
        
        interactor.timeCallbackSet(timeCallback)
        viewController.timeValue(timeValue)
        
        interactor.titleCallbackSet(titleCallback)
        viewController.titleValue(titleValue)
        
        interactor.performerCallbackSet(performerCallback)
        viewController.performerValue(performerValue)
        
        return viewController
    }
    
}
