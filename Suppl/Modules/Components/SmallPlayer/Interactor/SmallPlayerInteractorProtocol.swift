import Foundation

protocol SmallPlayerInteractorProtocol: class {
    
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func play()
    func navButtonClick(next: Bool)
    func rewindP()
    func rewindM()
    func clearPlayer()
    
}
