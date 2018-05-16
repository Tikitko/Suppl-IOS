import Foundation

class SearchBarPresenter: SearchBarPresenterProtocol {
    
    var router: SearchBarRouterProtocol!
    var interactor: SearchBarInteractorProtocol!
    weak var view: SearchBarViewControllerProtocol!
    
    func searchButtonClicked(query: String?) {
        guard let query = query else { return }
        interactor.listenerDelegate?.searchButtonClicked(query: query)
    }
}
