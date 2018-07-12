import Foundation
import UIKit

protocol TrackTablePresenterProtocolInteractor: class {
    var canEdit: Bool { get set }
    var moduleNameId: String { get }
    func setCellSetting(_ value: Bool)
    func reloadData()
    func setTracklist(_ tracklist: [String]?)
    func sendEditInfoToToast(expressionForTitle: LocalesManager.Expression, track: AudioData)
}
