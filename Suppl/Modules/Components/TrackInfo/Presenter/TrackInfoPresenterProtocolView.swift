import Foundation
import UIKit

protocol TrackInfoPresenterProtocolView: class {
    var isOffline: Bool { get }
    func setListeners()
    func clearTrack()
    func loadButtonClick()
    func requestOfflineMode()
    func getCellSelectColor() -> UIColor
}
