import Foundation
import UIKit

class TrackFilterRouter: ViperAssemblyRouter, TrackFilterRouterProtocol {
    typealias VIEW = TrackFilterViewController
    typealias PRESENTER = TrackFilterPresenter
    typealias INTERACTOR = TrackFilterInteractor
    
    static let submoduleName = "TrackFilter"
    
    static var submoduleBuildInfo: ViperModuleBuilderInfo {
        return .init(name: submoduleName, type: TrackFilterRouter.self, submodulesBuildersInfo: [])
    }
}
