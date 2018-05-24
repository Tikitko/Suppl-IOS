import Foundation
import UIKit

protocol TrackTablePresenterProtocol: class {
    func getModuleNameId() -> String
    func updateTracks()
    func relaodData()
    func resetCell(name: String)
    func updateCellInfo(trackIndex: Int, name: String)
    func load()
    func setTracklist(_ tracklist: [String]?)
    func createRowActions(indexPath: IndexPath) -> [RowAction]?
    func rowEditStatus(indexPath: IndexPath) -> Bool
    func openPlayer(trackIndex: Int)
    func willDisplayCellForRowAt(_ indexPath: IndexPath)
    func numberOfRowsInSection(_ section: Int) -> Int
    func moveTrack(fromPath: IndexPath, toPath: IndexPath)
    func canMoveTrack(fromPath: IndexPath) -> Bool 
    func sendEditInfoToToast(expressionForTitle: LocalesManager.Expression, track: AudioData)
}
