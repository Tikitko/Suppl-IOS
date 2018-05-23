import Foundation
import UIKit

protocol TrackInfoViewControllerProtocol: class {
    func setSelected(_ value: Bool, instantly: Bool)
    func setRoundImage(_ value: Bool)
    func setImage(image: UIImage)
    func setInfo(title: String, performer: String, durationString: String)
    func resetInfo()
}
