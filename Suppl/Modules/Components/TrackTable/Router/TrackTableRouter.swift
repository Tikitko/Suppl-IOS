import Foundation
import UIKit

class TrackTableRouter: ViperAssemblyRouter, TrackTableRouterProtocol {
    typealias VIEW = TrackTableViewController
    typealias PRESENTER = TrackTablePresenter
    typealias INTERACTOR = TrackTableInteractor
    
    func createCell(isSmall: Bool) -> (moduleNameId: String, controller: UIViewController) {
        let moduleInfo = TrackInfoRouter.setup(args: ["isSmall": isSmall])
        return (moduleInfo.id, moduleInfo.viewController)
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
