import Foundation
import UIKit

protocol PlayerPresenterProtocol: class {}

protocol PlayerPresenterProtocolInteractor: PlayerPresenterProtocol  {
    func updatePlayerProgress(currentTime: Double)
    func setNowTrack(track: CurrentTrack, status: Float?, currentTime: Double?)
}

protocol PlayerPresenterProtocolView: PlayerPresenterProtocol {
    func setListener()
    func firstLoad()
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func navButtonClick(next: Bool)
    func play()
    func rewindP()
    func rewindM()
    func closePlayer()
}
