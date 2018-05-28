import Foundation
import UIKit

protocol TrackInfoPresenterProtocol: class {}

protocol TrackInfoPresenterProtocolInteractor: TrackInfoPresenterProtocol {
    func getModuleNameId() -> String
    func additionalInfo(currentPlayingId: String?, roundImage: Bool)
}

protocol TrackInfoPresenterProtocolView: TrackInfoPresenterProtocol {
    func setListeners()
    func clearTrack()
}
