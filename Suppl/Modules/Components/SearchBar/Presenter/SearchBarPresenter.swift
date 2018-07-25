import Foundation

class SearchBarPresenter: SearchBarPresenterProtocolInteractor, SearchBarPresenterProtocolView {
    
    var router: SearchBarRouterProtocol!
    var interactor: SearchBarInteractorProtocol!
    weak var view: SearchBarViewControllerProtocol!
    
    func searchButtonClicked(query: String) {
        interactor.communicateDelegate?.searchButtonClicked(query: query)
    }
}
