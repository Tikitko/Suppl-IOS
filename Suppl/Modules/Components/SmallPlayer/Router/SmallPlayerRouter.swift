import Foundation
import UIKit

class SmallPlayerRouter: ViperBuildingRouter, SmallPlayerRouterProtocol {
    typealias VIEW = SmallPlayerViewController
    typealias PRESENTER = SmallPlayerPresenter
    typealias INTERACTOR = SmallPlayerInteractor
}
