import Foundation

class SearchBarInteractor: SearchBarInteractorProtocol {
    
    weak var presenter: SearchBarPresenterProtocolInteractor!
    
    let parentModuleNameId: String
    init(parentModuleNameId: String) {
        self.parentModuleNameId = parentModuleNameId
    }
    
    func getDelegate() -> SearchCommunicateProtocol? {
        return ModulesCommunicateManager.s.getListener(name: parentModuleNameId) as? SearchCommunicateProtocol
    }
    
}
