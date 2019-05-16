import Foundation
import UIKit

class MainRouter: ViperAssemblyRouter, MainRouterProtocol {
    typealias VIEW = MainViewController
    typealias PRESENTER = MainPresenter
    typealias INTERACTOR = MainInteractor
}
