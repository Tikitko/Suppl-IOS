import Foundation
import UIKit

protocol PlayerPresenterProtocol: class {
    func load()
    func setNavTitle(_ title: String)
    func setTrackInfo(title: String, performer: String)
    func setTrackImage(_ imageData: Data)
    func clearPlayer()
    func updatePlayerProgress(currentTime: Double)
    func openPlayer(duration: Double)
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func navButtonClick(next: Bool)
    func play()
    func rewindP()
    func rewindM()
    func setPlayImage()
    func setPauseImage()

}
