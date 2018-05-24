import Foundation

protocol SmallPlayerInteractorProtocol: class {
    func setListener(_ delegate: PlayerListenerDelegate)
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func play()
    func callNextTrack()
    func callPrevTrack()
    func clearPlayer()
}
