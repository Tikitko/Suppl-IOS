import Foundation

protocol TrackTableInteractorProtocol: class {
    var communicateDelegate: TrackTableCommunicateProtocol? { get }
    func getCellDelegate(name: String) -> TrackInfoCommunicateProtocol?
    func setTracklistListener(_ delegate: TracklistListenerDelegate)
    func setPlayerListener(_ delegate: PlayerListenerDelegate)
    func listenSettings()
    func requestOfflineStatus()
    func loadTracklist()
    func requestCellSetting()
    func reloadWhenChangingSettings()
    func openPlayer(tracksIDs: [String], trackIndex: Int, cachedTracksInfo: [AudioData]?)
    func addTrack(trackId: String, track: AudioData)
    func removeTrack(indexTrack: Int, track: AudioData)
    func moveTrack(from: Int, to: Int, track: AudioData)
    func loadImageData(link: String, callback: @escaping (_ data: Data) -> Void)
    func removeFromPlaylist(at: Int)
    func insertInPlaylist(track: AudioData)
}
