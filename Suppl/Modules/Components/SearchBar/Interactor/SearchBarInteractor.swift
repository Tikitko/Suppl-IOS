import Foundation

class SearchBarInteractor: SearchBarInteractorProtocol {
    
    weak var presenter: SearchBarPresenterProtocolInteractor!
    
    let parentModuleNameId: String
    init(parentModuleNameId: String) {
        self.parentModuleNameId = parentModuleNameId
    }
    
    var communicateDelegate: SearchCommunicateProtocol? {
        get { return ModulesCommunicateManager.shared.getListener(name: parentModuleNameId) as? SearchCommunicateProtocol }
    }
    
}
