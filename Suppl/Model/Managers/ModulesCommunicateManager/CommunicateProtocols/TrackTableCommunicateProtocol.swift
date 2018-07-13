import Foundation

protocol TrackTableCommunicateProtocol: CommunicateManagerProtocol {
    func cellShowAt(_ indexPath: IndexPath) -> Void
    func needTracksForReload() -> [AudioData]
    func removedTrack(fromIndex: Int)
    func addedTrack(withId: String)
    func moveTrack(from: Int, to: Int)
    func zoneRangePassed(toTop: Bool)
}
