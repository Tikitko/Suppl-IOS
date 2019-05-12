import Foundation
import UIKit

class MainRouter: ViperRouter, ViperConstructorProtocol, MainRouterProtocol {
    typealias VIEW = MainViewController
    typealias PRESENTER = MainPresenter
    typealias INTERACTOR = MainInteractor
}
