import Foundation

protocol TrackTableCommunicateProtocol: CommunicateManagerProtocol {
    func cellShowAt(_ indexPath: IndexPath) -> Void
    func needTracksForReload() -> TracklistPair
}