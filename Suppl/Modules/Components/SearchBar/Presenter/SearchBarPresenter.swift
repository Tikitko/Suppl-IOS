import Foundation

class SearchBarPresenter: ViperPresenter<SearchBarRouterProtocol, SearchBarInteractorProtocol, SearchBarViewControllerProtocol>, SearchBarPresenterProtocolInteractor, SearchBarPresenterProtocolView {
    
    func searchButtonClicked(query: String) {
        interactor.communicateDelegate?.searchButtonClicked(query: query)
    }
    
}
