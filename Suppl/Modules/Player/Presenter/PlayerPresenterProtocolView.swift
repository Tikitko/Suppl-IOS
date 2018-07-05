import Foundation
import UIKit

protocol PlayerPresenterProtocolView: class {
    func setListener()
    func firstLoad()
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func navButtonClick(next: Bool)
    func play()
    func rewindP()
    func rewindM()
    func closePlayer()
}
