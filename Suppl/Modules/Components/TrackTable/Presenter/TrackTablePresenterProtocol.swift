import Foundation
import UIKit

protocol TrackTablePresenterProtocol: class {}

protocol TrackTablePresenterProtocolInteractor: TrackTablePresenterProtocol {
    var canEdit: Bool { get set }
    func getModuleNameId() -> String
    func setTracklist(_ tracklist: [String]?)
    func sendEditInfoToToast(expressionForTitle: LocalesManager.Expression, track: AudioData)
}

protocol TrackTablePresenterProtocolView: TrackTablePresenterProtocol {
    var canEdit: Bool { get }
    func updateTracks()
    func relaodData()
    func resetCell(name: String)
    func updateCellInfo(trackIndex: Int, name: String)
    func load()
    func createRowActions(indexPath: IndexPath) -> [RowAction]?
    func rowEditStatus(indexPath: IndexPath) -> Bool
    func rowEditType(indexPath: IndexPath) -> UITableViewCellEditingStyle
    func openPlayer(trackIndex: Int)
    func willDisplayCellForRowAt(_ indexPath: IndexPath)
    func numberOfRowsInSection(_ section: Int) -> Int
    func moveTrack(fromPath: IndexPath, toPath: IndexPath)
    func canMoveTrack(fromPath: IndexPath) -> Bool
}
