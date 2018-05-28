import Foundation

protocol SmallPlayerInteractorProtocol: class {
    func setPlayerListener(_ delegate: PlayerListenerDelegate)
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func play()
    func callNextTrack()
    func callPrevTrack()
    func clearPlayer()
}
