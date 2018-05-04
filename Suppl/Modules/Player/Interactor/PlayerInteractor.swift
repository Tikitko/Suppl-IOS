import Foundation

class PlayerInteractor: PlayerInteractorProtocol {
    
    weak var presenter: PlayerPresenterProtocol!

    init(tracksIDs: [String], current: Int = 0) {
        PlayerManager.s.playerListener = self
        PlayerManager.s.setPlaylist(tracksIDs: tracksIDs, current: current)
    }
    
    func load() {
        presenter.setNavTitle(LocalesManager.s.get(.playerTitle))
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

    
}

extension PlayerInteractor: PlayerListenerDelegate {
    
    func playlistAdded(_ playlist: Playlist) {}
    
    func playlistRemoved() {}
    
    func blockControl() {
        presenter.clearPlayer()
    }
    
    func openControl() {
        guard let sec = PlayerManager.s.getRealDuration() else { return }
        presenter.openPlayer(duration: sec)
    }
    
    func curentTrackTime(sec: Double) {
        presenter.updatePlayerProgress(currentTime: sec)
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
