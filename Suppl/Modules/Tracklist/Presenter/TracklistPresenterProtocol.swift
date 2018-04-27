import Foundation
import UIKit

protocol TracklistPresenterProtocol: class {
    
    func updateButtonIsEnabled(_ value: Bool)
    func clearSearch()
    func setInfo(_ text: String?)
    func setSearchListener()
    func load()
    func updateButtonClick()
    func filterButtonClick()
    func setFilterThenPopover(filterController: UIViewController)
}
