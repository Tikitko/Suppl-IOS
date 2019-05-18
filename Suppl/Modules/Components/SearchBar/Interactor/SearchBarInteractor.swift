import Foundation

class SearchBarInteractor: ViperInteractor<SearchBarPresenterProtocolInteractor>, SearchBarInteractorProtocol {
    
    let parentModuleNameId: String
    
    required init(moduleId: String, parentModuleId: String?, args: [String : Any]) {
        self.parentModuleNameId = parentModuleId!
        super.init()
    }
    
    var communicateDelegate: SearchCommunicateProtocol? {
        get { return ModulesCommunicateManager.shared.getListener(name: parentModuleNameId) as? SearchCommunicateProtocol }
    }
    
}
