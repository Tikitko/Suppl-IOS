import Foundation

class SmallPlayerInteractor: SmallPlayerInteractorProtocol {
    
    weak var presenter: SmallPlayerPresenterProtocol!
    
    init() {
        PlayerManager.s.playerListenerTwo = self
    }
    
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool) {
        guard let nowSec = PlayerManager.s.getRealCurrentTime() else { return }
        PlayerManager.s.setPlayerCurrentTime(withCurrentTime ? nowSec + sec : sec)
    }
    
    func play() {
        PlayerManager.s.playOrPause()
    }
    
    func navButtonClick(next: Bool) {
        next ? PlayerManager.s.nextTrack(): PlayerManager.s.prevTrack()
    }
    
    func rewindP() {
        setPlayerCurrentTime(15, withCurrentTime: true)
    }
    
    func rewindM() {
        setPlayerCurrentTime(-15, withCurrentTime: true)
    }
    
    func clearPlayer() {
        PlayerManager.s.clearPlayer()
    }
    
}

extension SmallPlayerInteractor: PlayerListenerDelegate {
    
    func playlistAdded(_ playlist: Playlist) {
        presenter.showPlayer()
    }
    
    func playlistRemoved() {
        presenter.closePlayer()
    }
    
    func blockControl() {
        presenter.clearPlayer()
    }
    
    func openControl() {
        presenter.openPlayer()
    }
    
    func curentTrackTime(sec: Double) {
        guard let duration = PlayerManager.s.getRealDuration(), let currentTime = PlayerManager.s.getRealCurrentTime() else { return }
        presenter.updatePlayerProgress(percentages: Float(currentTime / duration))
    }
    
    func playerStop() {
        presenter.setPlayImage()
    }
    
    func playerPlay() {
        presenter.setPauseImage()
    }
    
    func trackInfoChanged(_ track: CurrentTrack) {
        presenter.setTrackInfo(title: track.title, performer: track.performer)
    }
    
    func trackImageChanged(_ imageData: Data) {
        presenter.setTrackImage(imageData)
    }
    
}
