import Foundation
import UIKit

class TrackInfoPresenter: TrackInfoPresenterProtocol {
    
    var router: TrackInfoRouterProtocol!
    var interactor: TrackInfoInteractorProtocol!
    weak var view: TrackInfoViewControllerProtocol!
    
    var trackId: String?
    
    func getModuleNameId() -> String {
        return router.moduleNameId
    }
    
    func setListeners() {
        interactor.setListener(self)
        interactor.setPlayerListener(self)
    }
    
    func setSelectedIfCurrent(id: String? = nil, instantly: Bool = false) {
        view.setSelected(id != nil && id == trackId, instantly: instantly)
    }
    
    func additionalInfo(currentPlayingId: String, roundImage: Bool) {
        view.setRoundImage(roundImage)
        setSelectedIfCurrent(id: currentPlayingId, instantly: true)
    }
    
    func clearTrack() {
        trackId = nil
    }
    
}

extension TrackInfoPresenter: PlayerListenerDelegate {

    func trackInfoChanged(_ track: CurrentTrack, _ imageData: Data?) {
        setSelectedIfCurrent(id: track.id)
    }
    
    func playlistRemoved() {
        setSelectedIfCurrent()
    }
    
}

extension TrackInfoPresenter: TrackInfoCommunicateProtocol {
    
    func setNewData(id: String, title: String, performer: String, duration: Int) {
        trackId = id
        interactor.requestAdditionalInfo()
        view.setInfo(title: title, performer: performer, durationString: TrackTime(sec: duration).formatted)
    }
    
    func setNewImage(imageData: NSData) {
        guard let image = UIImage(data: imageData as Data) else { return }
        view.setImage(image)
    }
    
    func needReset() {
        view.resetInfo()
    }
    
}
