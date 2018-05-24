import Foundation
import UIKit

protocol TrackInfoPresenterProtocol: class {
    func setListeners()
    func getModuleNameId() -> String
    func clearTrack()
    func additionalInfo(currentPlayingId: String, roundImage: Bool)
}
