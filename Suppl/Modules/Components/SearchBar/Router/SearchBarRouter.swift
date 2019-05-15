import Foundation
import UIKit

class SearchBarRouter: ViperBuildingRouter, SearchBarRouterProtocol {
    typealias VIEW = SearchBarViewController
    typealias PRESENTER = SearchBarPresenter
    typealias INTERACTOR = SearchBarInteractor
}
