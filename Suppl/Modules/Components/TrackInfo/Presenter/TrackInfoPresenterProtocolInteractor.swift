import Foundation
import UIKit

protocol TrackInfoPresenterProtocolInteractor: class {
    var moduleNameId: String { get }
    func additionalInfo(currentPlayingId: String?, roundImage: Bool)
}
