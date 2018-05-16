import Foundation

class SearchBarInteractor: SearchBarInteractorProtocol {
    
    weak var presenter: SearchBarPresenterProtocol!
    
    let parentModuleNameId: String
    init(parentModuleNameId: String) {
        self.parentModuleNameId = parentModuleNameId
    }
    
    var listenerDelegate: SearchCommunicateProtocol? {
        get { return ModulesCommunicateManager.s.getListener(name: parentModuleNameId) as? SearchCommunicateProtocol }
    }
    
}
