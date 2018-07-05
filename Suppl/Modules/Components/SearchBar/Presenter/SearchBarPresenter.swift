import Foundation

class SearchBarPresenter: SearchBarPresenterProtocolInteractor, SearchBarPresenterProtocolView {
    
    var router: SearchBarRouterProtocol!
    var interactor: SearchBarInteractorProtocol!
    weak var view: SearchBarViewControllerProtocol!
    
    func searchButtonClicked(query: String?) {
        guard let query = query else { return }
        interactor.communicateDelegate?.searchButtonClicked(query: query)
    }
}
