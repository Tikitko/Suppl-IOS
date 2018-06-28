import Foundation

final class TracklistManager {
    
    static public let s = TracklistManager()
    private init() {}
    
    private(set) var inUpdate: Bool = false
    private(set) var tracklist: [String]? {
        didSet {
            setDBTracklistBackground(tracklist)
            sayToListeners() { delegate in delegate.tracklistUpdated(tracklist) }
        }
    }
    
    private let mapTableDelegates = NSMapTable<NSString, AnyObject>(keyOptions: NSPointerFunctions.Options.strongMemory, valueOptions: NSPointerFunctions.Options.weakMemory)
    
    public func setListener(name: String, delegate: TracklistListenerDelegate) {
        mapTableDelegates.setObject(delegate, forKey: name as NSString)
    }
    
    private func getListener(name: String) -> TracklistListenerDelegate? {
        return mapTableDelegates.object(forKey: name as NSString) as? TracklistListenerDelegate
    }
    
    private func sayToListeners(_ callback: (TracklistListenerDelegate) -> Void) {
        for obj in mapTableDelegates.objectEnumerator() ?? NSEnumerator() {
            guard let delegate = obj as? TracklistListenerDelegate else { continue }
            callback(delegate)
        }
    }
    
    @available(*, deprecated)
    private func getDBTracklist() -> [String]? {
        guard let keys = AuthManager.s.getAuthKeys(), let coreDataWorker = CoreDataManager.s.getForegroundWorker() else { return nil }
        let predicate = NSPredicate(format: "userIdentifier = \(keys.identifierKey)")
        let sortDescriptor = NSSortDescriptor(key: #keyPath(UserTrack.position), ascending: true)
        guard let tracks = try? coreDataWorker.fetche(UserTrack.self, predicate: predicate, sortDescriptors: [sortDescriptor]) else { return nil }
        var tracklist: [String] = []
        for track in tracks {
            tracklist.append(track.trackId as String)
        }
        return tracklist
    }
    
    private func getDBTracklistBackground(completion: @escaping ([String]?) -> Void) {
        guard let keys = AuthManager.s.getAuthKeys(), let coreDataWorker = CoreDataManager.s.getBackgroundWorker() else {
            completion(nil)
            return
        }
        let predicate = NSPredicate(format: "userIdentifier = \(keys.identifierKey)")
        let sortDescriptor = NSSortDescriptor(key: #keyPath(UserTrack.position), ascending: true)
        coreDataWorker.fetche(UserTrack.self, predicate: predicate, sortDescriptors: [sortDescriptor]) { tracks, error in
            var tracklist: [String]? = nil
            if let tracks = tracks {
                tracklist = []
                for track in tracks {
                    tracklist?.append(track.trackId as String)
                }
            }
            DispatchQueue.main.async { completion(tracklist) }
        }
    }
    
    @available(*, deprecated)
    private func setDBTracklist(_ tracklist: [String]?) {
        guard let keys = AuthManager.s.getAuthKeys(), let coreDataWorker = CoreDataManager.s.getForegroundWorker() else { return }
        let predicate = NSPredicate(format: "userIdentifier = \(keys.identifierKey)")
        guard let tracklist = tracklist, let tracks = try? coreDataWorker.fetche(UserTrack.self, predicate: predicate) else { return }
        for track in tracks {
            guard !tracklist.contains(track.trackId as String) else { continue }
            coreDataWorker.delete(track)
        }
        for (key, trackId) in tracklist.enumerated() {
            if let readyTrackIndex = tracks.index(where: { $0.trackId == trackId as NSString }) {
                tracks[readyTrackIndex].position = NSNumber(value: key)
            } else {
                let newTrack = coreDataWorker.create(UserTrack.self)
                newTrack.userIdentifier = NSNumber(value: keys.identifierKey)
                newTrack.trackId = trackId as NSString
                newTrack.position = NSNumber(value: key)
            }
        }
        coreDataWorker.saveContext()
    }
    
    private func setDBTracklistBackground(_ tracklist: [String]?) {
        guard let keys = AuthManager.s.getAuthKeys(), let coreDataWorker = CoreDataManager.s.getBackgroundWorker(), let tracklist = tracklist else { return }
        let predicate = NSPredicate(format: "userIdentifier = \(keys.identifierKey)")
        coreDataWorker.run { inWorker in
            guard let tracks = try? inWorker.fetche(UserTrack.self, predicate: predicate) else { return }
            for track in tracks {
                guard !tracklist.contains(track.trackId as String) else { continue }
                inWorker.delete(track)
            }
            for (key, trackId) in tracklist.enumerated() {
                if let readyTrackIndex = tracks.index(where: { $0.trackId == trackId as NSString }) {
                    tracks[readyTrackIndex].position = NSNumber(value: key)
                } else {
                    let newTrack = inWorker.create(UserTrack.self)
                    newTrack.userIdentifier = NSNumber(value: keys.identifierKey)
                    newTrack.trackId = trackId as NSString
                    newTrack.position = NSNumber(value: key)
                }
            }
            inWorker.saveContext()
        }
    }
    
    public func update(callback: @escaping (Bool) -> () = { _ in }) {
        if OfflineModeManager.s.offlineMode {
            getDBTracklistBackground() { [weak self] tracklist in
                guard let `self` = self else { return }
                self.tracklist = tracklist
                callback(true)
            }
            return
        }
        guard !inUpdate, let keys = AuthManager.s.getAuthKeys() else {
            callback(false)
            return
        }
        inUpdate = true
        APIManager.s.tracklist.get(keys: keys) { [weak self] error, data in
            guard let `self` = self else { return }
            if let error = error, error.code == 40 {
                self.tracklist = []
                self.inUpdate = false
                callback(true)
                return
            }
            guard let data = data else {
                self.inUpdate = false
                callback(false)
                return
            }
            self.tracklist = data.list
            self.inUpdate = false
            callback(true)
        }
    }
    
    public func add(trackId: String, to: Int = 0, callback: @escaping (Bool) -> () = { _ in }) {
        guard let keys = AuthManager.s.getAuthKeys(), let tracklist = self.tracklist else {
            callback(false)
            return
        }
        if let _ = tracklist.index(of: trackId) {
            callback(false)
            return
        }
        APIManager.s.tracklist.add(keys: keys, trackID: trackId, to: to) { [weak self] error, status in
            guard let `self` = self else { return }
            if let _ = error {
                callback(false)
                return
            }
            self.tracklist?.insert(trackId, at: to)
            callback(true)
        }
    }
    
    public func remove(from: Int = 0, callback: @escaping (Bool) -> () = { _ in }) {
        guard let keys = AuthManager.s.getAuthKeys(),
            let tracklist = self.tracklist,
            from <= tracklist.count - 1 else
        {
            callback(false)
            return
        }
        APIManager.s.tracklist.remove(keys: keys, from: from) { [weak self] error, status in
            guard let `self` = self else { return }
            if let _ = error {
                callback(false)
                return
            }
            self.tracklist?.remove(at: from)
            callback(true)
        }
    }
    
    public func move(from: Int = 0, to: Int = 0, callback: @escaping (Bool) -> () = { _ in }) {
        guard let keys = AuthManager.s.getAuthKeys(),
            let tracklist = self.tracklist, from <= tracklist.count - 1,
            to <= tracklist.count else
        {
            callback(false)
            return
        }
        APIManager.s.tracklist.move(keys: keys, from: from, to: to) { [weak self] error, status in
            guard let `self` = self else { return }
            if let _ = error {
                callback(false)
                return
            }
            var tracklistTemp = tracklist
            tracklistTemp.remove(at: from)
            tracklistTemp.insert(tracklist[from], at: to)
            self.tracklist = tracklistTemp
            callback(true)
        }
    }
}
