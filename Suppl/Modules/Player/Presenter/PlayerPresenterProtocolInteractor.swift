import Foundation
import UIKit

protocol PlayerPresenterProtocolInteractor: class  {
    func updatePlayerProgress(currentTime: Double)
    func setNowTrack(track: CurrentTrack, status: Float?, currentTime: Double?)
}
