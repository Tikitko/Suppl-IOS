import Foundation
import UIKit

class TrackInfoRouter: ViperAssemblyRouter, TrackInfoRouterProtocol {
    typealias VIEW = TrackInfoViewController
    typealias PRESENTER = TrackInfoPresenter
    typealias INTERACTOR = TrackInfoInteractor
}
