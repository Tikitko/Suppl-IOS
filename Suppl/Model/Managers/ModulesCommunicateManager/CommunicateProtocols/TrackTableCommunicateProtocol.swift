import Foundation

protocol TrackTableCommunicateProtocol: CommunicateManagerProtocol {
    func cellShowAt(_ indexPath: IndexPath) -> Void
    func needTracksForReload() -> (tracks: [AudioData], foundTracks: [AudioData]?)
}
