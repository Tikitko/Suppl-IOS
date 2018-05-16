import Foundation

class TrackFilterPresenter: TrackFilterPresenterProtocol {
    
    var router: TrackFilterRouterProtocol!
    var interactor: TrackFilterInteractorProtocol!
    weak var view: TrackFilterViewControllerProtocol!
    
    func timeValue() -> Float? {
        return interactor.listenerDelegate?.timeValue()
    }
    func titleValue() -> Bool? {
        return interactor.listenerDelegate?.titleValue()
    }
    func performerValue() -> Bool? {
        return interactor.listenerDelegate?.performerValue()
    }
    
    func timeChange(_ value: inout Float) {
        interactor.listenerDelegate?.timeChange(&value)
    }
    func titleChange(_ value: inout Bool) {
        interactor.listenerDelegate?.titleChange(&value)
    }
    func performerChange(_ value: inout Bool) {
        interactor.listenerDelegate?.performerChange(&value)
    }
    
}
