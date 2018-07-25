import Foundation

protocol TrackTableCommunicateProtocol: CommunicateManagerProtocol {
    func cellShowAt(_ indexPath: IndexPath)
    func needTracksForReload() -> [AudioData]
    func removedTrack(fromIndex: Int)
    func addedTrack(withId: String)
    func moveTrack(from: Int, to: Int)
    func zoneRangePassed(toTop: Bool)
    func requestConfigure() -> TableConfigure
}

extension TrackTableCommunicateProtocol {
    func cellShowAt(_ indexPath: IndexPath) {}
    func removedTrack(fromIndex: Int) {}
    func addedTrack(withId: String) {}
    func moveTrack(from: Int, to: Int) {}
    func zoneRangePassed(toTop: Bool) {}
}
