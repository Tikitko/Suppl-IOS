import Foundation

class TrackFilterInteractor: TrackFilterInteractorProtocol {
    
    weak var presenter: TrackFilterPresenterProtocolInteractor!
    
    let parentModuleNameId: String
    init(parentModuleNameId: String) {
        self.parentModuleNameId = parentModuleNameId
    }
    
    func getDelegate() -> TrackFilterCommunicateProtocol? {
        return ModulesCommunicateManager.s.getListener(name: parentModuleNameId) as? TrackFilterCommunicateProtocol
    }

}
