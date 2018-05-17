import Foundation

protocol TrackTablePresenterProtocol: class {
    func updateTracks()
    func getTrackDataByIndex(_ index: Int, infoCallback: @escaping (_ data: AudioData) -> Void, imageCallback: @escaping (_ data: NSData) -> Void)
    func createRowActions(indexPath: IndexPath, actions: inout [RowAction])
    func rowEditStatus(indexPath: IndexPath) -> Bool
    func openPlayer(trackIndex: Int)
    func willDisplayCellForRowAt(_ indexPath: IndexPath)
    func numberOfRowsInSection(_ section: Int) -> Int
}
