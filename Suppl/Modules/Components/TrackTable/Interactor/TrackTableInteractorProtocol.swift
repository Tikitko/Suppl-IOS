import Foundation

protocol TrackTableInteractorProtocol: class, BaseInteractorProtocol {
    func getDelegate() -> TrackTableCommunicateProtocol?
    func getCellDelegate(name: String) -> TrackInfoCommunicateProtocol?
    func setTracklistListener(_ delegate: TracklistListenerDelegate)
    func laodTracklist()
    func openPlayer(tracksIDs: [String], trackIndex: Int, cachedTracksInfo: [AudioData]?)
    func addTrack(trackId: String, track: AudioData)
    func removeTrack(indexTrack: Int, track: AudioData)
    func moveTrack(from: Int, to: Int, track: AudioData)
    func loadImageData(link: String, callback: @escaping (_ data: NSData) -> Void)
}
