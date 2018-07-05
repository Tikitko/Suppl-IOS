import Foundation
import UIKit

protocol TracklistPresenterProtocolInteractor: class {
    var moduleNameId: String { get }
    func tracklistUpdateResult(status: Bool)
    func clearTracks()
    func setNewTrack(_ track: AudioData)
    func setUpdateResult(_ status: LocalesManager.Expression?)
    func offlineStatus(_ isOn: Bool)
}
