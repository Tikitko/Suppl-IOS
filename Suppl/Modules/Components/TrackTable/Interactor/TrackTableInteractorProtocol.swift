import Foundation

protocol TrackTableInteractorProtocol: class, BaseInteractorProtocol {
    func getDelegate() -> TrackTableCommunicateProtocol?
    func getCellDelegate(name: String) -> TrackInfoCommunicateProtocol?
    func setTracklistListener(_ delegate: TracklistListenerDelegate)
    func laodTracklist()
    func openPlayer(tracksIDs: [String], trackIndex: Int, cachedTracksInfo: [AudioData]?)
    func addTrack(trackId: String)
    func removeTrack(indexTrack: Int)
    func loadImageData(link: String, callback: @escaping (_ data: NSData) -> Void)
}
