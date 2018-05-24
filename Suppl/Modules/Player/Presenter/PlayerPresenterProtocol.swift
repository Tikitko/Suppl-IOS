import Foundation
import UIKit

protocol PlayerPresenterProtocol: class {
    func setListener()
    func firstLoad()
    func updatePlayerProgress(currentTime: Double)
    func setNowTrack(track: CurrentTrack, status: Float, currentTime: Double)
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func navButtonClick(next: Bool)
    func play()
    func rewindP()
    func rewindM()
    func closePlayer()
}
