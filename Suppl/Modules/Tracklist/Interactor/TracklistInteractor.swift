import Foundation

class TracklistInteractor: BaseInteractor, TracklistInteractorProtocol {
    
    weak var presenter: TracklistPresenterProtocolInteractor!
    
    var inSearchWork = false
    
    func setListener(_ delegate: CommunicateManagerProtocol) {
        ModulesCommunicateManager.s.setListener(name: presenter.getModuleNameId(), delegate: delegate)
    }
    
    func setTracklistListener(_ delegate: TracklistListenerDelegate) {
        TracklistManager.s.setListener(name: presenter.getModuleNameId(), delegate: delegate)
    }
    
    func updateTracks() {
        guard !inSearchWork, let tracklist = TracklistManager.s.tracklist else { return }
        presenter.clearTracks()
        if tracklist.count == 0 {
            presenter.setUpdateResult(.emptyTracklist)
            return
        }
        inSearchWork = true
        recursiveTracksLoad()
    }
    
    func recursiveTracksLoad(from: Int = 0, packCount count: Int = 10) {
        guard let tracklist = TracklistManager.s.tracklist else { return }
        let partCount = Int(ceil(Double(tracklist.count) / Double(count))) - 1
        if partCount * count < from {
            presenter.setUpdateResult(nil)
            inSearchWork = false
            return
        }
        guard let keys = getKeys() else { return }
        let tracklistPart = getTracklistPart(from: from, count: count)
        APIManager.s.audioGet(keys: keys, ids: tracklistPart.joined(separator: ",")) { [weak self] error, data in
            guard let `self` = self, let data = data else { return }
            for track in data.list {
                self.presenter.setNewTrack(track: track)
            }
            self.recursiveTracksLoad(from: from + count)
        }
    }
    
    func getTracklistPart(from: Int, count: Int) -> [String] {
        var tracklistPart: [String] = []
        for key in from...from+count-1 {
            guard let tracklist = TracklistManager.s.tracklist, key < tracklist.count else { break }
            tracklistPart.append(tracklist[key])
        }
        return tracklistPart
    }
    
    func tracklistUpdate() {
        TracklistManager.s.update() { [weak self] status in
            self?.presenter.tracklistUpdateResult(status: status)
        }
    }
    
}
