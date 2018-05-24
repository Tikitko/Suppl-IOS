import Foundation

class TrackFilterInteractor: TrackFilterInteractorProtocol {
    
    weak var presenter: TrackFilterPresenterProtocol!
    
    let parentModuleNameId: String
    init(parentModuleNameId: String) {
        self.parentModuleNameId = parentModuleNameId
    }
    
    func getDelegate() -> TrackFilterCommunicateProtocol? {
        return ModulesCommunicateManager.s.getListener(name: parentModuleNameId) as? TrackFilterCommunicateProtocol
    }

}
