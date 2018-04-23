import Foundation

class MainPresenter: MainPresenterProtocol {
    
    var router: MainRouterProtocol!
    var interactor: MainInteractorProtocol!
    weak var view: MainViewControllerProtocol!
    
    func setSearchQuery(_ query: String) {
        view.setSearchQuery(query)
    }
    
    func searchBarSearchButtonClicked(searchText: String) {
        interactor.searchBarSearchButtonClicked(searchText: searchText)
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
    
    func unload() {
        interactor.clearData(withReload: false)
    }
}
