import Foundation
import UIKit

protocol PlayerPresenterProtocol: class {
    func setListener()
    func firstLoad()
    func getCurrentTime() -> Double?
    func updatePlayerProgress(currentTime: Double)
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func navButtonClick(next: Bool)
    func play()
    func rewindP()
    func rewindM()
    func closePlayer()
}
