import Foundation

protocol SmallPlayerInteractorProtocol: class, BaseInteractorProtocol {
    func setPlayerListener(_ delegate: PlayerListenerDelegate)
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func play()
    func callNextTrack()
    func callPrevTrack()
    func clearPlayer()
}
