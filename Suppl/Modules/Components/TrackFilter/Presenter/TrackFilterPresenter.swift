import Foundation

class TrackFilterPresenter: TrackFilterPresenterProtocol {
    
    var router: TrackFilterRouterProtocol!
    var interactor: TrackFilterInteractorProtocol!
    weak var view: TrackFilterViewControllerProtocol!
    
    func timeIsEnabled(_ isEnabled: Bool) {
        view.timeIsEnabled(isEnabled)
    }
    
    func titleIsEnabled(_ isEnabled: Bool) {
        view.titleIsEnabled(isEnabled)
    }
    
    func performerIsEnabled(_ isEnabled: Bool) {
        view.performerIsEnabled(isEnabled)
    }
    
    func timeCallbackSet(_ timeCallback: @escaping ((_: inout Float) -> Void)) {
        interactor.timeCallbackSet(timeCallback)
    }
    
    func titleCallbackSet(_ titleCallback: @escaping ((_: inout Bool) -> Void)) {
        interactor.titleCallbackSet(titleCallback)
    }
    
    func performerCallbackSet(_ performerCallback: @escaping ((_: inout Bool) -> Void)) {
        interactor.performerCallbackSet(performerCallback)
    }
    
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
