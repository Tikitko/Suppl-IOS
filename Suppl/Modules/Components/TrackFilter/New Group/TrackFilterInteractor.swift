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
    
    func timeValue() -> Float? {
        return getDelegate()?.timeValue()
    }
    func titleValue() -> Bool? {
        return getDelegate()?.titleValue()
    }
    func performerValue() -> Bool? {
        return getDelegate()?.performerValue()
    }
    
    func timeChange(_ value: inout Float) {
        getDelegate()?.timeChange(&value)
    }
    func titleChange(_ value: inout Bool) {
        getDelegate()?.titleChange(&value)
    }
    func performerChange(_ value: inout Bool) {
        getDelegate()?.performerChange(&value)
    }
}
