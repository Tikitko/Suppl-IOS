import Foundation

protocol PlayerInteractorProtocol: class {
    
    func setListener(_ delegate: PlayerListenerDelegate)
    func getPlayerRate() -> Float?
    func getCurrentTrack() -> CurrentTrack?
    func getCurrentTime() -> Double?
    func getRealDuration() -> Double?
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func play()
    func callNextTrack()
    func callPrevTrack()

}
