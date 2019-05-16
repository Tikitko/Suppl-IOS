import Foundation
import UIKit

class TracklistRouter: ViperAssemblyRouter, TracklistRouterProtocol {
    typealias VIEW = TracklistViewController
    typealias PRESENTER = TracklistPresenter
    typealias INTERACTOR = TracklistInteractor
    
    let moduleNameId: String
    
    required init(moduleId: String, args: [String : Any]) {
        moduleNameId = moduleId
        super.init()
    }
    
    func showFilter() {
        guard let viewController = viewController as? TracklistViewController else { return }
        let filterView = TrackFilterRouter.setup(args: ["parentModuleId": moduleNameId]).viewController
        viewController.setFilterThenPopover(filterController: filterView)
        viewController.present(filterView, animated: true, completion: nil)
    }
    
}
