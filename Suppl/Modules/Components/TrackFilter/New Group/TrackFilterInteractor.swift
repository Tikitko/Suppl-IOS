import Foundation

class TrackFilterInteractor: TrackFilterInteractorProtocol {
    
    weak var presenter: TrackFilterPresenterProtocolInteractor!
    
    let parentModuleNameId: String
    init(parentModuleNameId: String) {
        self.parentModuleNameId = parentModuleNameId
    }
    
    var communicateDelegate: TrackFilterCommunicateProtocol? {
        get { return ModulesCommunicateManager.s.getListener(name: parentModuleNameId) as? TrackFilterCommunicateProtocol }
    }

}
