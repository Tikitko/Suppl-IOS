import Foundation

protocol TracklistRouterProtocol: class, BaseRouterProtocol {
    var moduleNameId: String { get }
    func showFilter()
}
