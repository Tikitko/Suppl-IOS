import Foundation
import UIKit

class SearchBarRouter: ViperAssemblyRouter, SearchBarRouterProtocol {
    typealias VIEW = SearchBarViewController
    typealias PRESENTER = SearchBarPresenter
    typealias INTERACTOR = SearchBarInteractor
}
