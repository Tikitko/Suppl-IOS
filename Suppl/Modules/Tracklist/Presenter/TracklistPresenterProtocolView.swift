import Foundation
import UIKit

protocol TracklistPresenterProtocolView: class {
    func load()
    func getTitle() -> String
    func updateButtonClick()
    func filterButtonClick()
}
