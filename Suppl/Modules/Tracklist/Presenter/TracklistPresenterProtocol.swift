import Foundation
import UIKit

protocol TracklistPresenterProtocol: class {
    
    func getModuleNameId() -> String
    func reloadData()
    func updateButtonIsEnabled(_ value: Bool)
    func clearSearch()
    func setListener()
    func setInfo(_ text: String?)
    func load()
    func updateButtonClick()
    func filterButtonClick()
    func setFilterThenPopover(filterController: UIViewController)
}
