import Foundation

class AuthPresenter: AuthPresenterProtocol {
    var router: AuthRouter!
    var interactor: AuthInteractor!
    var view: AuthViewController!
    
    func getNoAuthOnShow() -> Bool {
        return interactor.noAuthOnShow
    }
    
    func getKeys() -> (i: Int, a: Int)? {
        return interactor.getKeys()
    }
    
    func goToRoot() {
        router.goToRootTabBar()
    }
    
    func endAuth() {
        interactor.endAuth()
    }
    
    func auth(ikey: Int, akey: Int, report: @escaping (String?) -> ()) {
        interactor.auth(ikey: ikey, akey: akey, report: report)
    }
    
    func reg(report: @escaping (String?) -> ()) {
        interactor.reg(report: report)
    }
}
