import Foundation

class SearchBarInteractor: ViperInteractor<SearchBarPresenterProtocolInteractor>, SearchBarInteractorProtocol {
    
    let parentModuleNameId: String
    
    required init(moduleId: String, args: [String : Any]) {
        self.parentModuleNameId = args["parentModuleNameId"] as! String
        super.init()
    }
    
    var communicateDelegate: SearchCommunicateProtocol? {
        get { return ModulesCommunicateManager.shared.getListener(name: parentModuleNameId) as? SearchCommunicateProtocol }
    }
    
}
