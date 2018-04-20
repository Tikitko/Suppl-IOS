import Foundation

protocol TrackTablePresenterProtocol: class {
    func updateTracks(tracks: [AudioData], foundTracks: [AudioData]?)
    func openPlayer(tracksIDs: [String], current: Int)
    func numberOfRowsInSection(_ section: Int) -> Int
    func cellForRowAt(_ indexPath: IndexPath, _ cell: TrackTableCell) -> TrackTableCell
    func canEditRowAt(_ indexPath: IndexPath) -> Bool
    func editActionsForRowAt(_ indexPath: IndexPath) -> [RowAction]
    func didSelectRowAt(_ indexPath: IndexPath)
    func willDisplayCellForRowAt(_ indexPath: IndexPath)
}
