import Foundation
import UIKit

class TrackFilterRouter: ViperRouter, ViperConstructorProtocol, TrackFilterRouterProtocol {
    typealias VIEW = TrackFilterViewController
    typealias PRESENTER = TrackFilterPresenter
    typealias INTERACTOR = TrackFilterInteractor
}
