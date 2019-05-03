import Foundation
import UIKit

protocol TracklistPresenterProtocolInteractor: class {
    var moduleNameId: String { get }
    var canHideLogo: Bool? { get set }
    func tracklistUpdateResult(status: Bool)
    func clearTracks()
    func setNewTrack(_ track: AudioData)
    func setUpdateResult(localizationKey: String?)
    func offlineStatus(_ isOn: Bool)
}
