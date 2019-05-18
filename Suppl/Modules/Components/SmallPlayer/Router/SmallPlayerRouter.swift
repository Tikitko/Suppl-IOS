import Foundation
import UIKit

class SmallPlayerRouter: ViperAssemblyRouter, SmallPlayerRouterProtocol {
    typealias VIEW = SmallPlayerViewController
    typealias PRESENTER = SmallPlayerPresenter
    typealias INTERACTOR = SmallPlayerInteractor
    
    let trackTableModuleBuilder: (_ buildInfo: ViperModuleBuildInfo) -> ViperModuleInfo
    
    required init(moduleId: String, parentModuleId: String?, submodulesBuilders: [ViperModuleBuilder], args: [String : Any]) {
        trackTableModuleBuilder = submodulesBuilders.first(where: { $0.name == TrackTableRouter.submoduleName })!.builder
        super.init()
    }
    
    func createTrackTableModule() -> UITableViewController {
        return trackTableModuleBuilder(.init()).viewController as! UITableViewController
    }
    
    static func fullBuild(rootTabBarController: RootTabBarController) -> UIViewController{
        return build(
            submodulesBuildersInfo: [
                TrackTableRouter.submoduleBuildInfo
            ],
            buildInfo: .init([
                String(describing: RootTabBarController.self): rootTabBarController
            ])
        ).viewController
    }
    
}
