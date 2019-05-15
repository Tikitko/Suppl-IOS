import Foundation
import UIKit

class TrackInfoRouter: ViperBuildingRouter, TrackInfoRouterProtocol {
    typealias VIEW = TrackInfoViewController
    typealias PRESENTER = TrackInfoPresenter
    typealias INTERACTOR = TrackInfoInteractor
}
