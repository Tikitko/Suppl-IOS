import Foundation
import UIKit

protocol TracklistRouterProtocol {
    func createTrackTableModule() -> UITableViewController
    func createSearchBarModule() -> SearchBarViewController
    func showFilter()
}
