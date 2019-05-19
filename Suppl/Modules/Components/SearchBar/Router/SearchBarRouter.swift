import Foundation
import UIKit

class SearchBarRouter: ViperAssemblyRouter, SearchBarRouterProtocol {
    typealias VIEW = SearchBarViewController
    typealias PRESENTER = SearchBarPresenter
    typealias INTERACTOR = SearchBarInteractor
    
    static let submoduleName = "SearchBar"
    
    static var submoduleBuildInfo: ViperModuleBuilderInfo {
        return .init(name: submoduleName, type: SearchBarRouter.self, submodulesBuildersInfo: [])
    }
    
}
