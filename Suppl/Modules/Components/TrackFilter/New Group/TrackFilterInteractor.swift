import Foundation

class TrackFilterInteractor: ViperInteractor<TrackFilterPresenterProtocolInteractor>, TrackFilterInteractorProtocol {
    
    let parentModuleNameId: String
    
    required init(moduleId: String, args: [String : Any]) {
        self.parentModuleNameId = args["parentModuleId"] as! String
        super.init()
    }
    
    var communicateDelegate: TrackFilterCommunicateProtocol? {
        get { return ModulesCommunicateManager.shared.getListener(name: parentModuleNameId) as? TrackFilterCommunicateProtocol }
    }

}
