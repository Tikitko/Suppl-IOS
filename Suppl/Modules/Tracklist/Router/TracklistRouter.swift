import Foundation
import UIKit

class TracklistRouter: ViperAssemblyRouter, TracklistRouterProtocol {
    typealias VIEW = TracklistViewController
    typealias PRESENTER = TracklistPresenter
    typealias INTERACTOR = TracklistInteractor
    
    let filterView: UIViewController
    
    required init(moduleId: String, parentModuleId: String?, args: [String : Any]) {
        filterView = args["filter"] as! UIViewController
        super.init()
    }
    
    func showFilter() {
        guard let viewController = viewController as? TracklistViewController else { return }
        viewController.setFilterThenPopover(filterController: filterView)
        viewController.present(filterView, animated: true, completion: nil)
    }
    
}
