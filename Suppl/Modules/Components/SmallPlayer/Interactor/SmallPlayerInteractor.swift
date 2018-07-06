import Foundation

class SmallPlayerInteractor: BaseInteractor, SmallPlayerInteractorProtocol {
    
    weak var presenter: SmallPlayerPresenterProtocolInteractor!

    func setPlayerListener(_ delegate: PlayerListenerDelegate) {
        PlayerManager.s.setListener(name: NSStringFromClass(type(of: self)), delegate: delegate)
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
    
    func callMix() {
        PlayerManager.s.mixAndFirst()
    }
    
    func clearPlayer() {
        PlayerManager.s.clearPlayer()
    }
    
}
