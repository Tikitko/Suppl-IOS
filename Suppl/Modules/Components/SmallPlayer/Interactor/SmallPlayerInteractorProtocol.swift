import Foundation

protocol SmallPlayerInteractorProtocol: class, BaseInteractorProtocol {
    func setListener(_ delegate: CommunicateManagerProtocol)
    func setPlayerListener(_ delegate: PlayerListenerDelegate)
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func requestPlaylist()
    func play()
    func callNextTrack()
    func callPrevTrack()
    func callMix()
    func clearPlayer()
}
