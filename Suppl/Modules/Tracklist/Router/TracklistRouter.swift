import Foundation
import UIKit

class TracklistRouter: ViperAssemblyRouter, TracklistRouterProtocol {
    typealias VIEW = TracklistViewController
    typealias PRESENTER = TracklistPresenter
    typealias INTERACTOR = TracklistInteractor
    
    static func fullBuild() -> UIViewController {
        return build(
            submodulesBuildersInfo: [
                TrackTableRouter.submoduleBuildInfo,
                SearchBarRouter.submoduleBuildInfo,
                TrackFilterRouter.submoduleBuildInfo
            ]
        ).viewController
    }
    
    let filterModuleBuilder: ViperModuleBuilder
    let trackTableModuleBuilder: ViperModuleBuilder
    let searchBarModuleBuilder: ViperModuleBuilder
    
    required init(moduleId: String, parentModuleId: String?, submodulesBuilders: [ViperModuleNamedBuilder], args: [String : Any]) {
        filterModuleBuilder = submodulesBuilders.first(where: { $0.name == TrackFilterRouter.submoduleName })!.builder
        trackTableModuleBuilder = submodulesBuilders.first(where: { $0.name == TrackTableRouter.submoduleName })!.builder
        searchBarModuleBuilder = submodulesBuilders.first(where: { $0.name == SearchBarRouter.submoduleName })!.builder
        super.init()
    }
    
    func createTrackTableModule() -> UITableViewController {
        return trackTableModuleBuilder(.init()).viewController as! UITableViewController
    }
    
    func createSearchBarModule() -> SearchBarViewController {
        return searchBarModuleBuilder(.init()).viewController as! SearchBarViewController
    }
    
    func showFilter() {
        guard let viewController = viewController as? TracklistViewController else { return }
        let filterModule = filterModuleBuilder(.init())
        viewController.setFilterThenPopover(filterController: filterModule.viewController)
        viewController.present(filterModule.viewController, animated: true, completion: nil)
    }
    
}
