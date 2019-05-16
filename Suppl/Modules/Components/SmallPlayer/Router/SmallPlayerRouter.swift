import Foundation
import UIKit

class SmallPlayerRouter: ViperAssemblyRouter, SmallPlayerRouterProtocol {
    typealias VIEW = SmallPlayerViewController
    typealias PRESENTER = SmallPlayerPresenter
    typealias INTERACTOR = SmallPlayerInteractor
}
