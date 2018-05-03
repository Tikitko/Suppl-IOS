import Foundation

protocol TrackTablePresenterProtocol: class {
    func updateTracks()
    func openPlayer(tracksIDs: [String], current: Int)
    func numberOfRowsInSection(_ section: Int) -> Int
    func getTrackDataById(_ id: Int, infoCallback: @escaping (_ data: AudioData) -> Void, imageCallback: @escaping (_ data: NSData) -> Void)
    func canEditRowAt(_ indexPath: IndexPath) -> Bool
    func editActionsForRowAt(_ indexPath: IndexPath) -> [RowAction]
    func didSelectRowAt(_ indexPath: IndexPath)
    func willDisplayCellForRowAt(_ indexPath: IndexPath)
}
