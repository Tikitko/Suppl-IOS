import Foundation

class PlayerInteractor: PlayerInteractorProtocol {
    
    weak var presenter: PlayerPresenterProtocolInteractor!

    func setListener(_ delegate: PlayerListenerDelegate) {
        PlayerManager.s.setListener(name: NSStringFromClass(type(of: self)), delegate: delegate)
    }
    
    func loadNowTrack() {
        guard let currentTrack = PlayerManager.s.currentTrack, let status = PlayerManager.s.playerRate(), let time = PlayerManager.s.getRealCurrentTime() else { return }
        presenter.setNowTrack(track: currentTrack, status: status, currentTime: time)
    }
    
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool) {
        PlayerManager.s.setPlayerCurrentTime(withCurrentTime ? (PlayerManager.s.getRealCurrentTime() ?? 0) + sec : sec)
    }
    
    func play() {
        PlayerManager.s.playOrPause()
    }
    
    func callNextTrack() {
        PlayerManager.s.nextTrack()
    }
    
    func callPrevTrack() {
        PlayerManager.s.prevTrack()
    }
    
}
