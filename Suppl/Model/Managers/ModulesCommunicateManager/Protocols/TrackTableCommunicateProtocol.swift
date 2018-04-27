import Foundation

protocol TrackTableCommunicateProtocol {
    func cellShowAt(_ indexPath: IndexPath) -> Void
    func needTracksForReload() -> (tracks: [AudioData], foundTracks: [AudioData]?)
}
