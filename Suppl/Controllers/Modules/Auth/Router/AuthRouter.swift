import Foundation

class AuthRouter: AuthRouterProtocol {
    
    var viewController: AuthViewController!
    
    func goToRootTabBar() {
        viewController.present(RootTabBarController(), animated: true)
    }
    
}
