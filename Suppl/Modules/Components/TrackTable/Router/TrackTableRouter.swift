import Foundation
import UIKit

class TrackTableRouter: ViperBuildingRouter, TrackTableRouterProtocol {
    typealias VIEW = TrackTableViewController
    typealias PRESENTER = TrackTablePresenter
    typealias INTERACTOR = TrackTableInteractor
    
    func createCell(isSmall: Bool) -> (moduleNameId: String, controller: UIViewController) {
        let moduleId = TrackInfoRouter.generateModuleId()
        return (moduleId.value, TrackInfoRouter.setup(moduleId: moduleId, args: ["isSmall": isSmall]))
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
