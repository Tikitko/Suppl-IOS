import Foundation
import UIKit

protocol TracklistPresenterProtocol: class {
    func getModuleNameId() -> String
    func setListener()
    func setInfo(_ text: String?)
    func load()
    func unload()
    func tracklistUpdateResult(status: Bool)
    func updateButtonClick()
    func filterButtonClick()
    
    func clearTracks()
    func setNewTrack(track: AudioData)
    func setUpdateResult(_ status: LocalesManager.Expression?)
}
