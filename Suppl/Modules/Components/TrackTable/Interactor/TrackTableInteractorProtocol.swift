import Foundation

protocol TrackTableInteractorProtocol: class {
    func updateTracks()
    func numberOfRowsInSection(_ section: Int) -> Int
    func getTrackDataById(_ id: Int, infoCallback: @escaping (_ data: AudioData) -> Void, imageCallback: @escaping (_ data: NSData) -> Void)
    func canEditRowAt(_ indexPath: IndexPath) -> Bool
    func editActionsForRowAt(_ indexPath: IndexPath) -> [RowAction]
    func didSelectRowAt(_ indexPath: IndexPath)
    func willDisplayCellForRowAt(_ indexPath: IndexPath)
    func openPlayer(tracksIDs: [String], current: Int) 
}
