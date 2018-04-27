import Foundation
import UIKit

protocol TracklistViewControllerProtocol: class {
    func updateButtonIsEnabled(_ value: Bool)
    func setFilterThenPopover(filterController: UIViewController)
    func clearSearch()
    func onLabel(text: String)
    func offLabel()
}
