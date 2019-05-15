import Foundation
import UIKit

class MainRouter: ViperBuildingRouter, MainRouterProtocol {
    typealias VIEW = MainViewController
    typealias PRESENTER = MainPresenter
    typealias INTERACTOR = MainInteractor
}
