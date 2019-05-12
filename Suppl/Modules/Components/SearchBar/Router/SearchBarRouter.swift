import Foundation
import UIKit

class SearchBarRouter: ViperRouter, ViperConstructorProtocol, SearchBarRouterProtocol {
    typealias VIEW = SearchBarViewController
    typealias PRESENTER = SearchBarPresenter
    typealias INTERACTOR = SearchBarInteractor
}
