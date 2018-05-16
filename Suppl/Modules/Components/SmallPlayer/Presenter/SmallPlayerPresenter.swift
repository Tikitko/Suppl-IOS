import Foundation

class SmallPlayerPresenter: SmallPlayerPresenterProtocol {
    
    var router: SmallPlayerRouterProtocol!
    var interactor: SmallPlayerInteractorProtocol!
    weak var view: SmallPlayerViewControllerProtocol!
    
    func setListener() {
        PlayerManager.s.playerListenerTwo = self
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
    
    func openBigPlayer() {
        router.openBigPlayer()
    }
    
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool = false) {
        interactor.setPlayerCurrentTime(sec, withCurrentTime: withCurrentTime)
    }
    
    func removePlayer() {
        interactor.clearPlayer()
    }
    
}

extension SmallPlayerPresenter: PlayerListenerDelegate {
    
    func playlistAdded(_ playlist: Playlist) {
        view.showPlayer()
    }
    
    func playlistRemoved() {
        view.closePlayer()
    }
    
    func blockControl() {
        view.clearPlayer()
    }
    
    func openControl() {
        view.openPlayer()
    }
    
    func curentTrackTime(sec: Double) {
        guard let duration = interactor.getRealDuration(), let currentTime = interactor.getCurrentTime() else { return }
        view.updatePlayerProgress(percentages: Float(currentTime / duration))
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
