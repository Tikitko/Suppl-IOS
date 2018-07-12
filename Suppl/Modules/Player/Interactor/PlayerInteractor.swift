import Foundation

class PlayerInteractor: PlayerInteractorProtocol {
    
    weak var presenter: PlayerPresenterProtocolInteractor!

    func setPlayerListener(_ delegate: PlayerListenerDelegate) {
        PlayerManager.shared.setListener(name: NSStringFromClass(type(of: self)), delegate: delegate)
    }
    
    func loadNowTrack() {
        guard let currentTrack = PlayerManager.shared.currentTrack else { return }
        presenter.setNowTrack(track: currentTrack, status: PlayerManager.shared.playerRate, currentTime: PlayerManager.shared.currentItemTime)
    }
    
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool) {
        PlayerManager.shared.setPlayerCurrentTime(withCurrentTime ? (PlayerManager.shared.currentItemTime ?? 0) + sec : sec)
    }
    
    func play() {
        PlayerManager.shared.playOrPause()
    }
    
    func callNextTrack() {
        PlayerManager.shared.nextTrack()
    }
    
    func callPrevTrack() {
        PlayerManager.shared.prevTrack()
    }
    
}
