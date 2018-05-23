import Foundation
import UIKit

protocol TrackTablePresenterProtocol: class {
    func updateTracks()
    func resetCell(name: String)
    func updateCellInfo(trackIndex: Int, name: String)
    func createRowActions(indexPath: IndexPath, actions: inout [RowAction])
    func rowEditStatus(indexPath: IndexPath) -> Bool
    func openPlayer(trackIndex: Int)
    func willDisplayCellForRowAt(_ indexPath: IndexPath)
    func numberOfRowsInSection(_ section: Int) -> Int
}
