import Foundation

class PlayerInteractor: PlayerInteractorProtocol {
    
    weak var presenter: PlayerPresenterProtocol!

    func setListener(_ delegate: PlayerListenerDelegate) {
        PlayerManager.s.playerListenerOne = delegate
    }
    
    func getPlayerRate() -> Float? {
        return PlayerManager.s.playerRate()
    }
    
    func getCurrentTrack() -> CurrentTrack? {
        return PlayerManager.s.currentTrack
    }
    
    func getCurrentTime() -> Double? {
        return PlayerManager.s.getRealCurrentTime()
    }
    
    func getRealDuration() -> Double? {
        return PlayerManager.s.getRealDuration()
    }
    
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool) {
        PlayerManager.s.setPlayerCurrentTime(withCurrentTime ? (getCurrentTime() ?? 0) + sec : sec)
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
