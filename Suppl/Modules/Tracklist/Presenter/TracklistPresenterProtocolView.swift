import Foundation
import UIKit

protocol TracklistPresenterProtocolView: class {
    func load()
    func getTitle() -> String
    func getLoadLabel() -> String
    func getSearchLabel() -> String
    func updateButtonClick()
    func filterButtonClick()
}
