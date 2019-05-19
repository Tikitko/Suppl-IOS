import Foundation
import UIKit

class TrackTableRouter: ViperAssemblyRouter, TrackTableRouterProtocol {
    typealias VIEW = TrackTableViewController
    typealias PRESENTER = TrackTablePresenter
    typealias INTERACTOR = TrackTableInteractor
    
    static let submoduleName = "TrackTable"
    private static let submoduleCellName = "TrackInfo"
    
    let cellModuleBuilder: ViperModuleBuilder
    
    required init(moduleId: String, parentModuleId: String?, submodulesBuilders: [ViperModuleNamedBuilder], args: [String : Any]) {
        cellModuleBuilder = submodulesBuilders.first(where: { $0.name == TrackTableRouter.submoduleCellName })!.builder
        super.init()
    }
    
    static var submoduleBuildInfo: ViperModuleBuilderInfo {
        return .init(name: submoduleName, type: TrackTableRouter.self, submodulesBuildersInfo: [
            .init(name: submoduleCellName, type: TrackInfoRouter.self, submodulesBuildersInfo: [])
        ])
    }
    
    func createCell(isSmall: Bool) -> (moduleId: String, viewController: UIViewController) {
        let cellModule = cellModuleBuilder(.init(["isSmall": isSmall]))
        return (cellModule.id, cellModule.viewController)
    }
    
    func showToastOnTop(title: String, body: String, duration: Double = 2.0) {
        viewController.view.superview?.makeToast(
            body,
            duration: duration,
            position: .top,
            title: title
        )
    }
    
}
