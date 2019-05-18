import Foundation
import UIKit

class MainRouter: ViperAssemblyRouter, MainRouterProtocol {
    typealias VIEW = MainViewController
    typealias PRESENTER = MainPresenter
    typealias INTERACTOR = MainInteractor
    
    static func fullBuild() -> UIViewController {
        return build(
            submodulesBuildersInfo: [
                TrackTableRouter.submoduleBuildInfo,
                SearchBarRouter.submoduleBuildInfo
            ]
        ).viewController
    }
    
    let trackTableModuleBuilder: ViperModuleBuilder
    let searchBarModuleBuilder: ViperModuleBuilder
    
    required init(moduleId: String, parentModuleId: String?, submodulesBuilders: [ViperModuleNamedBuilder], args: [String : Any]) {
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
    
}
