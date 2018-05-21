import Foundation
import UIKit

class TrackTableCellPresenter: TrackTableCellPresenterProtocol {
    
    var router: TrackTableCellRouterProtocol!
    var interactor: TrackTableCellInteractorProtocol!
    weak var view: TrackTableCellViewControllerProtocol!
    
    var cellTrackId: String?
    
    func getModuleNameId() -> String {
        return router.moduleNameId
    }
    
    func setListeners() {
        interactor.setListener(self)
        interactor.setPlayerListener(self)
    }
    
    func setSelectedIfCurrent(id: String? = nil, instantly: Bool = false) {
        view.setSelected(id != nil && id == cellTrackId, instantly: instantly)
    }
    
    func clearTrack() {
        cellTrackId = nil
    }
    
}

extension TrackTableCellPresenter: PlayerListenerDelegate {
    
    func trackInfoChanged(_ track: CurrentTrack) {
        setSelectedIfCurrent(id: track.id)
    }
    
    func playlistRemoved() {
        setSelectedIfCurrent()
    }
    
}

extension TrackTableCellPresenter: TrackTableCellCommunicateProtocol {
    
    func setNewData(id: String, title: String, performer: String, duration: Int) {
        view.setRoundImage(interactor.getLoadImageSetting())
        cellTrackId = id
        view.setInfo(title: title, performer: performer, durationString: TrackTime(sec: duration).formatted)
        setSelectedIfCurrent(id: interactor.getCurrentTrackId(), instantly: true)
    }
    
    func setNewImage(imageData: NSData) {
        guard let image = UIImage(data: imageData as Data) else { return }
        view.setImage(image: image)
    }
    
}
