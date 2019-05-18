import Foundation
import UIKit

protocol MainRouterProtocol: class {
    func createTrackTableModule() -> UITableViewController
    func createSearchBarModule() -> SearchBarViewController
}
