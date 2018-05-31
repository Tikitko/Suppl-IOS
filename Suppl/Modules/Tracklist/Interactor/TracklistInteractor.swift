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
    
    func requestOfflineStatus() {
        presenter.offlineStatus(getOfflineStatus())
    }
    
    func updateTracks() {
        guard !inSearchWork, let tracklist = TracklistManager.s.tracklist else { return }
        presenter.clearTracks()
        if tracklist.count == 0 {
            presenter.setUpdateResult(.emptyTracklist)
            return
        }
        if getOfflineStatus() {
            guard let tracksDB = getDBTracks(), tracksDB.count > 0 else {
                presenter.setUpdateResult(.emptyTracklist)
                return
            }
            for track in tracksDB {
                presenter.setNewTrack(track)
            }
            presenter.setUpdateResult(nil)
        } else {
            inSearchWork = true
            recursiveTracksLoad()
        }
    }
    
    func setDBTracks(_ tracks: [AudioData]) {
        guard let tracksDB = try? CoreDataManager.s.fetche(Track.self), let userTracksDB = try? CoreDataManager.s.fetche(UserTrack.self) else { return }
        for trackDB in tracksDB {
            guard !tracks.contains(where: { $0.id == trackDB.id as String }), !userTracksDB.contains(where: { $0.trackId == trackDB }) else { continue }
            CoreDataManager.s.persistentContainer.viewContext.delete(trackDB)
        }
        for track in tracks {
            if let readyTrackIndex = tracksDB.index(where: { $0.id as String == track.id }) {
                tracksDB[readyTrackIndex].fromAudioData(track)
            } else {
                CoreDataManager.s.create(Track.self).fromAudioData(track)
            }
        }
    }
    
    func getDBTracks() -> [AudioData]? {
        let sortDescriptor = NSSortDescriptor(key: #keyPath(UserTrack.position), ascending: true)
        guard let tracksDB = try? CoreDataManager.s.fetche(Track.self), let userTracksDB = try? CoreDataManager.s.fetche(UserTrack.self, sortDescriptors: [sortDescriptor]) else { return nil }
        var tracks = [AudioData]()
        for userTrack in userTracksDB {
            guard let trackIndex = tracksDB.index(where: { $0.id == userTrack.trackId }) else { continue }
            tracks.append(AudioData(track: tracksDB[trackIndex]))
        }
        return tracks
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
            guard let data = data else {
                self?.inSearchWork = false
                return
            }
            for track in data.list {
                self?.presenter.setNewTrack(track)
            }
            self?.recursiveTracksLoad(from: from + count)
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
