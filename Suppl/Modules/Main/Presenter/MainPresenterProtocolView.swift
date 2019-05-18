import Foundation
import UIKit

protocol MainPresenterProtocolView: class {
    func load()
    func getTitle() -> String
    func getLoadLabel() -> String
    func getSearchLabel() -> String
    func createTrackTableModule() -> UITableViewController
    func createSearchBarModule() -> SearchBarViewController
}
