import Foundation
import UIKit

protocol TrackInfoPresenterProtocol: class {}

protocol TrackInfoPresenterProtocolInteractor: TrackInfoPresenterProtocol {
    var moduleNameId: String { get }
    func additionalInfo(currentPlayingId: String?, roundImage: Bool)
}

protocol TrackInfoPresenterProtocolView: TrackInfoPresenterProtocol {
    func setListeners()
    func clearTrack()
}
