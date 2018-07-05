import Foundation

class PlayerInteractor: PlayerInteractorProtocol {
    
    weak var presenter: PlayerPresenterProtocolInteractor!

    func setPlayerListener(_ delegate: PlayerListenerDelegate) {
        PlayerManager.s.setListener(name: NSStringFromClass(type(of: self)), delegate: delegate)
    }
    
    func loadNowTrack() {
        guard let currentTrack = PlayerManager.s.currentTrack else { return }
        presenter.setNowTrack(track: currentTrack, status: PlayerManager.s.playerRate, currentTime: PlayerManager.s.currentItemTime)
    }
    
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool) {
        PlayerManager.s.setPlayerCurrentTime(withCurrentTime ? (PlayerManager.s.currentItemTime ?? 0) + sec : sec)
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
