import Foundation

class TracklistInteractor: ViperInteractor<TracklistPresenterProtocolInteractor>, TracklistInteractorProtocol {
    
    var inSearchWork = false
    
    func setListener(_ delegate: CommunicateManagerProtocol) {
        ModulesCommunicateManager.shared.setListener(name: presenter.moduleNameId, delegate: delegate)
    }
    
    func setTracklistListener(_ delegate: TracklistListenerDelegate) {
        TracklistManager.shared.setListener(name: presenter.moduleNameId, delegate: delegate)
    }
    
    func requestOfflineStatus() {
        presenter.offlineStatus(OfflineModeManager.shared.offlineMode)
    }
    
    func listenSettings() {
        SettingsManager.shared.hideLogo.addObserver(self, selector: #selector(requestHideLogoSetting))
    }
    
    @objc func requestHideLogoSetting() {
        presenter.canHideLogo = SettingsManager.shared.hideLogo.value
    }
    
    func updateTracks() {
        guard !inSearchWork, let tracklist = TracklistManager.shared.tracklist else { return }
        presenter.clearTracks()
        if tracklist.count == 0 {
            presenter.setUpdateResult(localizationKey: "emptyTracklist")
            return
        }
        inSearchWork = true
        getDBTracksBackground() { [weak self] tracks in
            self?.loadTracks(tracklist: tracklist, cachedTracks: tracks)
        }
    }
    
    func loadTracks(tracklist: [String], cachedTracks: [AudioData]? = nil) {
        if OfflineModeManager.shared.offlineMode {
            guard let cachedTracks = cachedTracks, cachedTracks.count > 0 else {
                inSearchWork = false
                presenter.setUpdateResult(localizationKey: "emptyTracklist")
                return
            }
            for track in cachedTracks {
                presenter.setNewTrack(track)
            }
            inSearchWork = false
            presenter.setUpdateResult(localizationKey: nil)
        } else {
            recursiveTracksLoadNew(cachedTracks: cachedTracks ?? [], tracklist: tracklist, apiLoadRate: /* Backend fix: Start */ AppDelegate.enableBackendFixes ? 1 : 10 /* Backend fix: End */)
        }
    }
    
    @available(*, deprecated)
    func setDBTracks(_ tracks: [AudioData]) {
        guard let coreDataWorker = CoreDataManager.shared.getForegroundWorker() else { return }
        let tracksDB = coreDataWorker.fetch(Track.self)
        let userTracksDB = coreDataWorker.fetch(UserTrack.self)
        for trackDB in tracksDB {
            guard !tracks.contains(where: { $0.id == trackDB.id as String }),
                  !userTracksDB.contains(where: { $0.trackId == trackDB })
                else { continue }
            coreDataWorker.delete([trackDB])
        }
        for track in tracks {
            if tracksDB.firstIndex(where: { $0.id as String == track.id }) != nil { continue }
            coreDataWorker.create(Track.self).fromAudioData(track)
        }
        try? coreDataWorker.saveContext()
    }
    
    func setDBTracksBackground(_ tracks: [AudioData]) {
        guard let coreDataWorker = CoreDataManager.shared.getBackgroundWorker() else { return }
        coreDataWorker.run { worker in
            let tracksDB = worker.fetch(Track.self)
            let userTracksDB = worker.fetch(UserTrack.self)
            for trackDB in tracksDB {
                guard !tracks.contains(where: { $0.id == trackDB.id as String }),
                      !userTracksDB.contains(where: { $0.trackId == trackDB })
                    else { continue }
                worker.delete([trackDB])
            }
            for track in tracks {
                if tracksDB.firstIndex(where: { $0.id as String == track.id }) != nil { continue }
                worker.create(Track.self).fromAudioData(track)
            }
            try? worker.saveContext()
        }
    }
    
    func saveTracks(_ tracks: [AudioData]) {
        setDBTracksBackground(tracks)
    }
    
    @available(*, deprecated)
    func getDBTracks() -> [AudioData]? {
        guard let keys = AuthManager.shared.getAuthKeys(),
              let coreDataWorker = CoreDataManager.shared.getForegroundWorker()
            else { return nil }
        let sortDescriptor = NSSortDescriptor(key: #keyPath(UserTrack.position), ascending: true)
        let tracksDB = coreDataWorker.fetch(Track.self)
        let userTracksDB = coreDataWorker.fetch(UserTrack.self, predicate: keys.identifierPredicate, sortDescriptors: [sortDescriptor])
        var tracks: [AudioData] = []
        for userTrack in userTracksDB {
            guard let trackIndex = tracksDB.firstIndex(where: { $0.id == userTrack.trackId }) else { continue }
            tracks.append(AudioData(track: tracksDB[trackIndex]))
        }
        return tracks
    }
 
    func getDBTracksBackground(completion: @escaping ([AudioData]?) -> Void) {
        guard let keys = AuthManager.shared.getAuthKeys(),
              let coreDataWorker = CoreDataManager.shared.getBackgroundWorker()
            else {
            completion(nil)
            return
        }
        let sortDescriptor = NSSortDescriptor(key: #keyPath(UserTrack.position), ascending: true)
        coreDataWorker.run { inWorker in
            var tracks: [AudioData] = []
            let tracksDB = inWorker.fetch(Track.self)
            let userTracksDB = inWorker.fetch(UserTrack.self, predicate: keys.identifierPredicate, sortDescriptors: [sortDescriptor])
            for userTrack in userTracksDB {
                guard let trackIndex = tracksDB.firstIndex(where: { $0.id == userTrack.trackId }) else { continue }
                tracks.append(AudioData(track: tracksDB[trackIndex]))
            }
            DispatchQueue.main.async { completion(tracks) }
        }
    }
    
    @available(*, deprecated)
    func recursiveTracksLoad(from: Int = 0, packCount count: Int = 10) {
        guard let keys = AuthManager.shared.getAuthKeys(),
              let tracklist = TracklistManager.shared.tracklist
            else { return }
        let partCount = Int(ceil(Double(tracklist.count) / Double(count))) - 1
        if partCount * count < from {
            presenter.setUpdateResult(localizationKey: nil)
            inSearchWork = false
            return
        }
        let tracklistPart = getTracklistPart(tracklist, from: from, count: count)
        APIManager.shared.audio.get(keys: keys, ids: tracklistPart) { [weak self] error, data in
            guard let data = data else {
                self?.inSearchWork = false
                return
            }
            for track in data.list {
                self?.presenter.setNewTrack(track)
            }
            self?.recursiveTracksLoad(from: from + count, packCount: count)
        }
    }
    
    func getTracklistPart(_ tracklist: [String], from: Int, count: Int) -> [String] {
        var tracklistPart: [String] = []
        for key in from...from + count - 1 {
            guard key < tracklist.count else { break }
            tracklistPart.append(tracklist[key])
        }
        return tracklistPart
    }
    
    func recursiveTracksLoadNew(cachedTracks: [AudioData] = [], tracklist: [String]? = nil, from: Int = 0, apiLoadRate: Int = 10) {
        guard let keys = AuthManager.shared.getAuthKeys(),
              let tracklist = tracklist ?? TracklistManager.shared.tracklist
            else { return }
        if from > tracklist.count - 1 {
            presenter.setUpdateResult(localizationKey: nil)
            inSearchWork = false
            return
        }
        var lastKey = from
        var tracksForAdd: [AudioData] = []
        var tracklistPartForLoad: [String] = []
        for key in from...tracklist.count - 1 {
            if tracklistPartForLoad.count >= apiLoadRate { break }
            defer { lastKey = key }
            if let index = cachedTracks.firstIndex(where: { $0.id == tracklist[key] }) {
                tracksForAdd.append(cachedTracks[index])
            } else {
                tracklistPartForLoad.append(tracklist[key])
            }
        }
        let addTracks: (_ loadedTracks: [AudioData]) -> Void = { [weak self] tracks in
            for key in from...lastKey {
                if let indexCached = tracksForAdd.firstIndex(where: { $0.id == tracklist[key] }) {
                    self?.presenter.setNewTrack(tracksForAdd[indexCached])
                } else if let indexLoaded = tracks.firstIndex(where: { $0.id == tracklist[key] }) {
                    self?.presenter.setNewTrack(tracks[indexLoaded])
                }
            }
            self?.recursiveTracksLoadNew(cachedTracks: cachedTracks, tracklist: tracklist, from: lastKey + 1, apiLoadRate: apiLoadRate)
        }
        if tracklistPartForLoad.count == 0 {
            addTracks([])
            return
        }
        APIManager.shared.audio.get(keys: keys, ids: tracklistPartForLoad) { [weak self] error, data in
            guard let data = data, data.list.count == tracklistPartForLoad.count else {
                self?.presenter.setUpdateResult(localizationKey: "serverError")
                self?.inSearchWork = false
                return
            }
            addTracks(data.list)
        }
    }
    
    func tracklistUpdate() {
        TracklistManager.shared.update() { [weak self] status in
            self?.presenter.tracklistUpdateResult(status: status)
        }
    }
    
}
