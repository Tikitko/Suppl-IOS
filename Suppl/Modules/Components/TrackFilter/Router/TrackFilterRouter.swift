import Foundation
import UIKit

class TrackFilterRouter: ViperBuildingRouter, TrackFilterRouterProtocol {
    typealias VIEW = TrackFilterViewController
    typealias PRESENTER = TrackFilterPresenter
    typealias INTERACTOR = TrackFilterInteractor
}
