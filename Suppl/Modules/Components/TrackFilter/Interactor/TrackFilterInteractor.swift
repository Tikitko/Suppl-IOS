import Foundation

class TrackFilterInteractor: TrackFilterInteractorProtocol {
    
    weak var presenter: TrackFilterPresenterProtocol!
    
    var timeCallback: ((_: inout Float) -> Void)?
    var titleCallback: ((_: inout Bool) -> Void)?
    var performerCallback: ((_: inout Bool) -> Void)?
    
    func timeCallbackSet(_ timeCallback: ((_: inout Float) -> Void)?) {
        guard let timeCallback = timeCallback else { return }
        self.timeCallback = timeCallback
        presenter.timeIsEnabled(true)
    }
    
    func titleCallbackSet(_ titleCallback: ((_: inout Bool) -> Void)?) {
        guard let titleCallback = titleCallback else { return }
        self.titleCallback = titleCallback
        presenter.titleIsEnabled(true)
    }
    
    func performerCallbackSet(_ performerCallback: ((_: inout Bool) -> Void)?) {
        guard let performerCallback = performerCallback else { return }
        self.performerCallback = performerCallback
        presenter.performerIsEnabled(true)
    }
    
    func timeCallbackFunc(_ value: inout Float) {
        guard let timeCallback = timeCallback else { return }
        timeCallback(&value)
    }
    
    func titleCallbackFunc(_ value: inout Bool) {
        guard let titleCallback = titleCallback else { return }
        titleCallback(&value)
        presenter.titleIsEnabled(true)
    }
    
    func performerCallbackFunc(_ value: inout Bool) {
        guard let performerCallback = performerCallback else { return }
        performerCallback(&value)
    }

}
