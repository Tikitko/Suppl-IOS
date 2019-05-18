import Foundation
import UIKit

protocol SmallPlayerPresenterProtocolView: class {
    func setListener()
    func getTitle() -> String
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func navButtonClick(next: Bool)
    func play()
    func rewindP()
    func rewindM()
    func mixButtonClick()
    func removePlayer()
    func createTrackTableModule() -> UITableViewController
}
