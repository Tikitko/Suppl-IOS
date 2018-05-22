import Foundation

protocol TrackTableInteractorProtocol: class {
    func getDelegate() -> TrackTableCommunicateProtocol?
    func getCellDelegate(name: String) -> TrackTableCellCommunicateProtocol?
    func openPlayer(tracksIDs: [String], trackIndex: Int, cachedTracksInfo: [AudioData]?)
    func getTracklist() -> [String]?
    func addTrack(trackId: String)
    func removeTrack(indexTrack: Int)
    func getKeys() -> KeysPair?
    func getLocaleString(_ forKey: LocalesManager.Expression) -> String
    func loadImageData(link: String, callback: @escaping (_ data: NSData) -> Void)
}
