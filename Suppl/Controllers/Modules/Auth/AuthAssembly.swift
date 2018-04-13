import Foundation

class AuthAssembly {
    static func create(noAuth noAuthOnShow: Bool) -> AuthRouter {
        let router = AuthRouter()
        let interactor = AuthInteractor()
        interactor.noAuthOnShow = noAuthOnShow
        let presenter = AuthPresenter()
        let viewController = AuthViewController()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController
        
        router.viewController = viewController
        
        viewController.presenter = presenter
        
        interactor.presenter = presenter
        
        return router
    }
}
