import Foundation

class TrackFilterInteractor: TrackFilterInteractorProtocol {
    
    weak var presenter: TrackFilterPresenterProtocol!

    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func timeCallbackFunc(_ value: inout Float) {
        //NotificationManager.post(toSection: "FilterTimeCallback", toName: name, info: value)
    }
    
    func titleCallbackFunc(_ value: inout Bool) {
        //NotificationManager.post(toSection: "FilterTitleCallback", toName: name, info: value)
    }
    
    func performerCallbackFunc(_ value: inout Bool) {
        //NotificationManager.post(toSection: "FilterPerformerCallback", toName: name, info: value)
    }
    
    deinit {
        /*
        let _ = NotificationManager.removeListener(name, fromSection: "FilterTimeCallback")
        let _ = NotificationManager.removeListener(name, fromSection: "FilterTitleCallback")
        let _ = NotificationManager.removeListener(name, fromSection: "FilterPerformerCallback")
 */
    }

}
