import Foundation

protocol TrackTableCommunicateProtocol: class {
    func cellShowAt(_ indexPath: IndexPath) -> Void
    func needTracksForReload() -> (tracks: [AudioData], foundTracks: [AudioData]?)
}
