import Foundation
import UIKit

protocol TracklistPresenterProtocol: class {}

protocol TracklistPresenterProtocolInteractor: TracklistPresenterProtocol {
    func getModuleNameId() -> String
    func tracklistUpdateResult(status: Bool)
    func clearTracks()
    func setNewTrack(track: AudioData)
    func setUpdateResult(_ status: LocalesManager.Expression?)
}

protocol TracklistPresenterProtocolView: TracklistPresenterProtocol {
    func load()
    func updateButtonClick()
    func filterButtonClick()
}

