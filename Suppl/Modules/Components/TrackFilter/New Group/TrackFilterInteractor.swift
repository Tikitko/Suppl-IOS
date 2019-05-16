import Foundation

class TrackFilterInteractor: ViperInteractor<TrackFilterPresenterProtocolInteractor>, TrackFilterInteractorProtocol {
    
    let parentModuleNameId: String
    
    required init(moduleId: String, parentModuleId: String?, args: [String : Any]) {
        self.parentModuleNameId = parentModuleId!
        super.init()
    }
    
    var communicateDelegate: TrackFilterCommunicateProtocol? {
        get { return ModulesCommunicateManager.shared.getListener(name: parentModuleNameId) as? TrackFilterCommunicateProtocol }
    }

}
