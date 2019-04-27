import Foundation
import UIKit

protocol TrackTablePresenterProtocolView: class {
    var canEdit: Bool { get }
    func loadConfigure()
    func updateTracks()
    func reloadData()
    func requestCellSetting()
    func resetCell(name: String)
    func updateCellInfo(trackIndex: Int, name: String)
    func load()
    func createRowActions(indexPath: IndexPath) -> [RowAction]?
    func reloadWhenChangingSettings()
    func rowEditStatus(indexPath: IndexPath) -> Bool
    func rowEditType(indexPath: IndexPath) -> UITableViewCell.EditingStyle
    func openPlayer(trackIndex: Int)
    func willDisplayCellForRowAt(_ indexPath: IndexPath)
    func numberOfRowsInSection(_ section: Int) -> Int
    func moveTrack(fromPath: IndexPath, toPath: IndexPath)
    func canMoveTrack(fromPath: IndexPath) -> Bool
    func sayThatZonePassed(toTop: Bool)
    func setCellSetup(name: String, light: Bool, downloadButton: Bool)
    func getCell(small: Bool) -> (moduleNameId: String, controller: UIViewController)
}
