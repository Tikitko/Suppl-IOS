import Foundation

class TracklistInteractor: BaseInteractor, TracklistInteractorProtocol {
    
    weak var presenter: TracklistPresenterProtocolInteractor!
    
    var inSearchWork = false
    
    func setListener(_ delegate: CommunicateManagerProtocol) {
        ModulesCommunicateManager.s.setListener(name: presenter.moduleNameId, delegate: delegate)
    }
    
    func setTracklistListener(_ delegate: TracklistListenerDelegate) {
        TracklistManager.s.setListener(name: presenter.moduleNameId, delegate: delegate)
    }
    
    func requestOfflineStatus() {
        presenter.offlineStatus(OfflineModeManager.s.offlineMode)
    }
    
    func updateTracks() {
        guard !inSearchWork, let tracklist = TracklistManager.s.tracklist else { return }
        presenter.clearTracks()
        if tracklist.count == 0 {
            presenter.setUpdateResult(.emptyTracklist)
            return
        }
        if OfflineModeManager.s.offlineMode {
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
            recursiveTracksLoadNew(cachedTracks: getDBTracks() ?? [], tracklist: tracklist)
        }
    }
    
    func setDBTracks(_ tracks: [AudioData]) {
        guard let tracksDB = try? CoreDataManager.s.fetche(Track.self), let userTracksDB = try? CoreDataManager.s.fetche(UserTrack.self) else { return }
        for trackDB in tracksDB {
            guard !tracks.contains(where: { $0.id == trackDB.id as String }), !userTracksDB.contains(where: { $0.trackId == trackDB }) else { continue }
            CoreDataManager.s.persistentContainer.viewContext.delete(trackDB)
        }
        for track in tracks {
            if tracksDB.index(where: { $0.id as String == track.id }) == nil {
                CoreDataManager.s.create(Track.self).fromAudioData(track)
            }
        }
    }
    
    func getDBTracks() -> [AudioData]? {
        let sortDescriptor = NSSortDescriptor(key: #keyPath(UserTrack.position), ascending: true)
        guard let keys = AuthManager.s.getAuthKeys(), let tracksDB = try? CoreDataManager.s.fetche(Track.self), let userTracksDB = try? CoreDataManager.s.fetche(UserTrack.self, predicate: NSPredicate(format: "userIdentifier = \(keys.identifierKey)"), sortDescriptors: [sortDescriptor]) else { return nil }
        var tracks = [AudioData]()
        for userTrack in userTracksDB {
            guard let trackIndex = tracksDB.index(where: { $0.id == userTrack.trackId }) else { continue }
            tracks.append(AudioData(track: tracksDB[trackIndex]))
        }
        return tracks
    }
    
    @available(*, deprecated)
    func recursiveTracksLoad(from: Int = 0, packCount count: Int = 10) {
        guard let keys = AuthManager.s.getAuthKeys(), let tracklist = TracklistManager.s.tracklist else { return }
        let partCount = Int(ceil(Double(tracklist.count) / Double(count))) - 1
        if partCount * count < from {
            presenter.setUpdateResult(nil)
            inSearchWork = false
            return
        }
        let tracklistPart = getTracklistPart(tracklist, from: from, count: count)
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
    
    func getTracklistPart(_ tracklist: [String], from: Int, count: Int) -> [String] {
        var tracklistPart: [String] = []
        for key in from...from+count-1 {
            guard key < tracklist.count else { break }
            tracklistPart.append(tracklist[key])
        }
        return tracklistPart
    }
    
    func recursiveTracksLoadNew(cachedTracks: [AudioData] = [], tracklist: [String]? = nil, from: Int = 0, apiLoadRate: Int = 10) {
        guard let keys = AuthManager.s.getAuthKeys(), let tracklist = tracklist ?? TracklistManager.s.tracklist else { return }
        if from > tracklist.count - 1 {
            presenter.setUpdateResult(nil)
            inSearchWork = false
            return
        }
        var lastKey = from
        var tracksForAdd: [AudioData] = []
        var tracklistPartForLoad: [String] = []
        for key in from...tracklist.count - 1 {
            defer { lastKey = key }
            if tracklistPartForLoad.count >= apiLoadRate { break }
            if let index = cachedTracks.index(where: { $0.id == tracklist[key] }) {
                tracksForAdd.append(cachedTracks[index])
            } else {
                tracklistPartForLoad.append(tracklist[key])
            }
        }
        let addTracks: (_ loadedTracks: [AudioData]) -> Void = { [weak self] tracks in
            for key in from...lastKey {
                if let indexCached = tracksForAdd.index(where: { $0.id == tracklist[key] }) {
                    self?.presenter.setNewTrack(tracksForAdd[indexCached])
                } else if let indexLoaded = tracks.index(where: { $0.id == tracklist[key] }) {
                    self?.presenter.setNewTrack(tracks[indexLoaded])
                }
            }
            self?.recursiveTracksLoadNew(cachedTracks: cachedTracks, tracklist: tracklist, from: lastKey + 1)
        }
        if tracklistPartForLoad.count == 0 {
            addTracks([])
            return
        }
        APIManager.s.audioGet(keys: keys, ids: tracklistPartForLoad.joined(separator: ",")) { [weak self] error, data in
            guard let data = data, data.list.count == tracklistPartForLoad.count else {
                self?.presenter.setUpdateResult(.serverError)
                self?.inSearchWork = false
                return
            }
            addTracks(data.list)
        }
    }
    
    func tracklistUpdate() {
        TracklistManager.s.update() { [weak self] status in
            self?.presenter.tracklistUpdateResult(status: status)
        }
    }
    
}
