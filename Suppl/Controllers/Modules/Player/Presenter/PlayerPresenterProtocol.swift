import Foundation
import UIKit

protocol PlayerPresenterProtocol: class {
    func load()
    func show()
    func setTrackInfo(title: String, performer: String)
    func setTrackImage(_ image: UIImage)
    func clearPlayer()
    func startObservers()
    func stopObservers()
    func updatePlayerProgress(currentTime: Double)
    func addPlayerTimeObserver()
    func openPlayer(duration: Double)
    func setPlayButtonImage(_ image: UIImage)
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func navButtonClick(next: Bool)
    func play()
}
