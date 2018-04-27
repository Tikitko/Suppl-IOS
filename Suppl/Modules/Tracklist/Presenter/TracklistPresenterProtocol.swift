import Foundation
import UIKit

protocol TracklistPresenterProtocol: class {
    
    func reloadData()
    func updateButtonIsEnabled(_ value: Bool)
    func clearSearch()
    func setInfo(_ text: String?)
    func setSearchListener()
    func setTableListener()
    func load()
    func updateButtonClick()
    func filterButtonClick()
    func setFilterThenPopover(filterController: UIViewController)
}
