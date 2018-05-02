import Foundation

class SearchBarInteractor: SearchBarInteractorProtocol {
    
    weak var presenter: SearchBarPresenterProtocol!
    
    let parentModuleNameId: String
    init(parentModuleNameId: String) {
        self.parentModuleNameId = parentModuleNameId
    }
    
    func getDelegate() -> SearchCommunicateProtocol? {
        return ModulesCommunicateManager.s.getListener(name: parentModuleNameId) as? SearchCommunicateProtocol
    }
    
    func searchButtonClicked(query: String) {
        getDelegate()?.searchButtonClicked(query: query)
    }
    
}
