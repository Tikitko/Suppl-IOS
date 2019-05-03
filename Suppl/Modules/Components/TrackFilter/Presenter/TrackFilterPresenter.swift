import Foundation

class TrackFilterPresenter: TrackFilterPresenterProtocolInteractor, TrackFilterPresenterProtocolView {
    
    var router: TrackFilterRouterProtocol!
    var interactor: TrackFilterInteractorProtocol!
    weak var view: TrackFilterViewControllerProtocol!
    
    func timeValue() -> Float? {
        return interactor.communicateDelegate?.timeValue()
    }
    func titleValue() -> Bool? {
        return interactor.communicateDelegate?.titleValue()
    }
    func performerValue() -> Bool? {
        return interactor.communicateDelegate?.performerValue()
    }
    
    func timeChange(_ value: inout Float) {
        interactor.communicateDelegate?.timeChange(&value)
    }
    func titleChange(_ value: inout Bool) {
        interactor.communicateDelegate?.titleChange(&value)
    }
    func performerChange(_ value: inout Bool) {
        interactor.communicateDelegate?.performerChange(&value)
    }
    
}
