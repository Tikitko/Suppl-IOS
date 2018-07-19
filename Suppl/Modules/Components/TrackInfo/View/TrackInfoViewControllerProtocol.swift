import Foundation
import UIKit

protocol TrackInfoViewControllerProtocol: class {
    var allowDownloadButton: Bool { get set }
    var lightStyle: Bool { get set }
    func setSelected(_ value: Bool, instantly: Bool)
    func setRoundImage(_ value: Bool)
    func setImage(_ image: UIImage)
    func setInfo(title: String, performer: String, durationString: String)
    func resetInfo()
    func turnLoad(_ isOn: Bool)
    func setLoadPercentages(_ percentages: Int)
    func turnLoadImage(_ isOn: Bool)
    func turnLoadButton(_ isOn: Bool)
    func setLoadButtonType(_ type: TrackInfoViewController.LoadButtonType)
    func enableLoadButton(_ isOn: Bool)
}
