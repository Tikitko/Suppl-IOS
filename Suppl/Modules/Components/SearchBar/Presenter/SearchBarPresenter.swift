import Foundation

class SearchBarPresenter: SearchBarPresenterProtocol {
    
    var router: SearchBarRouterProtocol!
    var interactor: SearchBarInteractorProtocol!
    weak var view: SearchBarViewControllerProtocol!
    
    func searchButtonClicked(query: String) {
        interactor.searchButtonClicked(query: query)
    }
}
