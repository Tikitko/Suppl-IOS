import Foundation
import UIKit

class SmallPlayerRouter: ViperRouter, ViperConstructorProtocol, SmallPlayerRouterProtocol {
    typealias VIEW = SmallPlayerViewController
    typealias PRESENTER = SmallPlayerPresenter
    typealias INTERACTOR = SmallPlayerInteractor
}
