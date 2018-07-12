import Foundation

class SmallPlayerInteractor: BaseInteractor, SmallPlayerInteractorProtocol {
    
    weak var presenter: SmallPlayerPresenterProtocolInteractor!

    func setPlayerListener(_ delegate: PlayerListenerDelegate) {
        PlayerManager.shared.setListener(name: NSStringFromClass(type(of: self)), delegate: delegate)
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
    
    func callMix() {
        PlayerManager.shared.mixAndFirst()
    }
    
    func clearPlayer() {
        PlayerManager.shared.clearPlayer()
    }
    
}
