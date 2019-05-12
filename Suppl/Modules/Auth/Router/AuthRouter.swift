import Foundation
import UIKit

class AuthRouter: ViperRouter, ViperConstructorProtocol, AuthRouterProtocol {
    typealias VIEW = AuthViewController
    typealias PRESENTER = AuthPresenter
    typealias INTERACTOR = AuthInteractor
    
    func goToRootTabBar() {
        viewController.view.window?.rootViewController = RootTabBarController()
    }
    
    static func setSelf(noAuth noAuthOnShow: Bool = false) {
        UIApplication.shared.keyWindow?.rootViewController = setup(args: ["noAuthOnShow": noAuthOnShow])
    }
    
}
