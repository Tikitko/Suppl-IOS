import Foundation
import UIKit

protocol SmallPlayerPresenterProtocolView: class {
    func setListener()
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func navButtonClick(next: Bool)
    func play()
    func rewindP()
    func rewindM()
    func openBigPlayer()
    func removePlayer()
}
