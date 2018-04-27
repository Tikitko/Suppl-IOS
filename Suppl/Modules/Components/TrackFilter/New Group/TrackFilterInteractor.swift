import Foundation

class TrackFilterInteractor: TrackFilterInteractorProtocol {
    
    weak var presenter: TrackFilterPresenterProtocol!
    
    func timeValue() -> Float? {
        return ModulesCommunicateManager.s.trackFilterDelegate?.timeValue()
    }
    func titleValue() -> Bool? {
        return ModulesCommunicateManager.s.trackFilterDelegate?.titleValue()
    }
    func performerValue() -> Bool? {
        return ModulesCommunicateManager.s.trackFilterDelegate?.performerValue()
    }
    
    func timeChange(_ value: inout Float) {
        ModulesCommunicateManager.s.trackFilterDelegate?.timeChange(&value)
    }
    func titleChange(_ value: inout Bool) {
        ModulesCommunicateManager.s.trackFilterDelegate?.titleChange(&value)
    }
    func performerChange(_ value: inout Bool) {
        ModulesCommunicateManager.s.trackFilterDelegate?.performerChange(&value)
    }
}
