import Foundation

class TrackFilterPresenter: TrackFilterPresenterProtocol {
    
    var router: TrackFilterRouterProtocol!
    var interactor: TrackFilterInteractorProtocol!
    weak var view: TrackFilterViewControllerProtocol!
    
    func timeCallbackFunc(_ value: inout Float) {
        interactor.timeCallbackFunc(&value)
    }
    
    func titleCallbackFunc(_ value: inout Bool) {
        interactor.titleCallbackFunc(&value)
    }
    
    func performerCallbackFunc(_ value: inout Bool) {
        interactor.performerCallbackFunc(&value)
    }
    
}
