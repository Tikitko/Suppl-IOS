import Foundation

class TrackFilterPresenter: TrackFilterPresenterProtocolInteractor, TrackFilterPresenterProtocolView {
    
    var router: TrackFilterRouterProtocol!
    var interactor: TrackFilterInteractorProtocol!
    weak var view: TrackFilterViewControllerProtocol!
    
    func timeValue() -> Float? {
        return interactor.getDelegate()?.timeValue()
    }
    func titleValue() -> Bool? {
        return interactor.getDelegate()?.titleValue()
    }
    func performerValue() -> Bool? {
        return interactor.getDelegate()?.performerValue()
    }
    
    func timeChange(_ value: inout Float) {
        interactor.getDelegate()?.timeChange(&value)
    }
    func titleChange(_ value: inout Bool) {
        interactor.getDelegate()?.titleChange(&value)
    }
    func performerChange(_ value: inout Bool) {
        interactor.getDelegate()?.performerChange(&value)
    }
    
}
