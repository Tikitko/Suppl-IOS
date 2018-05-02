import Foundation

class MainPresenter: MainPresenterProtocol {
    
    var router: MainRouterProtocol!
    var interactor: MainInteractorProtocol!
    weak var view: MainViewControllerProtocol!
    
    func getModuleNameId() -> String {
        return router.moduleNameId
    }
    
    func setSearchQuery(_ query: String) {
        view.setSearchQuery(query)
    }
    
    func reloadData() {
        view.reloadData()
    }
    
    func setInfo(_ text: String? = nil) {
        text != nil ? view.onLabel(text: text!) : view.offLabel()
    }
    
    func setOffsetZero() {
        view.setOffsetZero()
    }
    
    func load() {
        interactor.loadBaseTracks()
    }
    
    func setListener() {
        interactor.setListener()
    }
    
}
