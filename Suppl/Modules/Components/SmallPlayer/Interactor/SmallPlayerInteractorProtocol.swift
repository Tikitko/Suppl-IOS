import Foundation

protocol SmallPlayerInteractorProtocol: class {
    
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func play()
    func callNextTrack()
    func callPrevTrack()
    func clearPlayer()
    func getCurrentTime() -> Double? 
    func getRealDuration() -> Double?
    
}