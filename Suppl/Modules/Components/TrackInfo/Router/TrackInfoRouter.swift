import Foundation
import UIKit

class TrackInfoRouter: ViperRouter, ViperConstructorProtocol, TrackInfoRouterProtocol {
    typealias VIEW = TrackInfoViewController
    typealias PRESENTER = TrackInfoPresenter
    typealias INTERACTOR = TrackInfoInteractor
}
