import Foundation

protocol PlayerInteractorProtocol: class {
    func loadNowTrack()
    func setListener(_ delegate: PlayerListenerDelegate)
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func play()
    func callNextTrack()
    func callPrevTrack()
}
