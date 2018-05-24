import Foundation
import UIKit

protocol TracklistPresenterProtocol: class {
    func getModuleNameId() -> String
    func setInfo(_ text: String?)
    func load()
    func tracklistUpdateResult(status: Bool)
    func updateButtonClick()
    func filterButtonClick()
    func clearTracks()
    func setNewTrack(track: AudioData)
    func setUpdateResult(_ status: LocalesManager.Expression?)
}
