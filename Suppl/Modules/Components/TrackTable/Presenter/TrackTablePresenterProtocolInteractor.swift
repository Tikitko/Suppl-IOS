import Foundation
import UIKit

protocol TrackTablePresenterProtocolInteractor: class {
    var canEdit: Bool { get set }
    var frashTracklist: [String]? { get set }
    var moduleNameId: String { get }
    func setCellSetting(_ value: Bool)
    func reloadData()
    func sendEditInfoToToast(localizationKeyForTitle: String, track: AudioData)
}
