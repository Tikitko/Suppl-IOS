import Foundation
import UIKit

class TrackFilterRouter: ViperAssemblyRouter, TrackFilterRouterProtocol {
    typealias VIEW = TrackFilterViewController
    typealias PRESENTER = TrackFilterPresenter
    typealias INTERACTOR = TrackFilterInteractor
}
