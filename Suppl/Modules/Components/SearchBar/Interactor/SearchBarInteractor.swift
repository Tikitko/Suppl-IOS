import Foundation

class SearchBarInteractor: SearchBarInteractorProtocol {
    
    weak var presenter: SearchBarPresenterProtocol!
    
    func searchButtonClicked(query: String) {
        ModulesCommunicateManager.s.searchDelegate?.searchButtonClicked(query: query)
    }
    
}
