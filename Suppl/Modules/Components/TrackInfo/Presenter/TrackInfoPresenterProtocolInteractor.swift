import Foundation
import UIKit

protocol TrackInfoPresenterProtocolInteractor: class {
    var moduleNameId: String { get }
    var isOffline: Bool { get set }
    func additionalInfo(currentPlayingId: String?, roundImage: Bool, downloadedStatus status: PlayerItemsManager.ItemStatus, lastLoadPercentages: Int?)
    func controlEnabled(_ value: Bool)
}
