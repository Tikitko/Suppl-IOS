import Foundation

class TrackFilterPresenter: TrackFilterPresenterProtocol {
    
    var router: TrackFilterRouterProtocol!
    var interactor: TrackFilterInteractorProtocol!
    weak var view: TrackFilterViewControllerProtocol!
    
    func timeValue() -> Float? {
        return interactor.timeValue()
    }
    func titleValue() -> Bool? {
        return interactor.titleValue()
    }
    func performerValue() -> Bool? {
        return interactor.performerValue()
    }
    
    func timeChange(_ value: inout Float) {
        interactor.timeChange(&value)
    }
    func titleChange(_ value: inout Bool) {
        interactor.titleChange(&value)
    }
    func performerChange(_ value: inout Bool) {
        interactor.performerChange(&value)
    }
    
}
