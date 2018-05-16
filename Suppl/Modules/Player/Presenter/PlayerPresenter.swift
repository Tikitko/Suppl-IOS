import Foundation
import UIKit

class PlayerPresenter: PlayerPresenterProtocol {
    
    var router: PlayerRouterProtocol!
    var interactor: PlayerInteractorProtocol!
    weak var view: PlayerViewControllerProtocol!
    
    func setListener() {
        interactor.setListener(self)
    }
    
    func firstLoad() {
        guard let nowTrack = interactor.getCurrentTrack() else { return }
        view.loadNowTrack(track: nowTrack, playerRate: interactor.getPlayerRate() ?? 0)
    }
    
    func getCurrentTime() -> Double? {
        return interactor.getCurrentTime()
    }
    
    func updatePlayerProgress(currentTime: Double) {
        view.updatePlayerProgress(currentTime: currentTime)
    }
    
    func navButtonClick(next: Bool) {
        next ? interactor.callNextTrack() : interactor.callPrevTrack()
    }
    
    func play() {
        interactor.play()
    }
    
    func rewindP() {
        interactor.setPlayerCurrentTime(15, withCurrentTime: true)
    }
    
    func rewindM() {
        interactor.setPlayerCurrentTime(-15, withCurrentTime: true)
    }

    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool = false) {
        interactor.setPlayerCurrentTime(sec, withCurrentTime: withCurrentTime)
    }
    
    func closePlayer() {
        router.closePlayer()
    }
    
}

extension PlayerPresenter: PlayerListenerDelegate {
    
    func playlistAdded(_ playlist: Playlist) {}
    
    func playlistRemoved() {}
    
    func blockControl() {
        view.clearPlayer()
    }
    
    func openControl() {
        guard let sec = interactor.getRealDuration() else { return }
        view.openPlayer(duration: sec)
    }
    
    func curentTrackTime(sec: Double) {
        view.updatePlayerProgress(currentTime: sec)
    }
    
    func playerStop() {
        view.setPlayImage()
    }
    
    func playerPlay() {
        view.setPauseImage()
    }
    
    func trackInfoChanged(_ track: CurrentTrack) {
        view.setTrackInfo(title: track.title, performer: track.performer)
    }
    
    func trackImageChanged(_ imageData: Data) {
        view.setTrackImage(imageData)
    }
    
}
