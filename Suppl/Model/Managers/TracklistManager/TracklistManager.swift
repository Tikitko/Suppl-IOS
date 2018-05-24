import Foundation

final class TracklistManager {
    
    static public let s = TracklistManager()
    private init() {}
    
    private(set) var inUpdate: Bool = false
    private(set) var tracklist: [String]? {
        didSet {
            sayToListeners() { delegate in delegate.tracklistUpdated(tracklist) }
        }
    }
    
    private let mapTableDelegates = NSMapTable<NSString, AnyObject>(keyOptions: NSPointerFunctions.Options.strongMemory, valueOptions: NSPointerFunctions.Options.weakMemory)
    
    public func setListener(name: String, delegate: TracklistListenerDelegate) {
        mapTableDelegates.setObject(delegate, forKey: name as NSString)
    }
    
    private  func getListener(name: String) -> TracklistListenerDelegate? {
        return mapTableDelegates.object(forKey: name as NSString) as? TracklistListenerDelegate
    }
    
    private func sayToListeners(_ callback: (TracklistListenerDelegate) -> Void) {
        for obj in mapTableDelegates.objectEnumerator() ?? NSEnumerator() {
            guard let delegate = obj as? TracklistListenerDelegate else { continue }
            callback(delegate)
        }
    }
    
    public func update(callback: @escaping (Bool) -> ()) {
        guard !inUpdate, let keys = AuthManager.s.getAuthKeys() else {
            callback(false)
            return
        }
        inUpdate = true
        APIManager.s.tracklistGet(keys: keys) { [weak self] error, data in
            guard let `self` = self else { return }
            if let error = error, error.domain == "music_tracklist_empty" {
                self.tracklist = []
                self.inUpdate = false
                callback(false)
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
    
    public func add(trackId: String, to: Int = 0, callback: @escaping (Bool) -> ()) {
        guard let keys = AuthManager.s.getAuthKeys(), let tracklist = self.tracklist else
        {
            callback(false)
            return
        }
        if let _ = tracklist.index(of: trackId) {
            callback(false)
            return
        }
        APIManager.s.tracklistAdd(keys: keys, trackID: trackId, to: to) { [weak self] error, status in
            guard let `self` = self else { return }
            if let _ = error {
                callback(false)
                return
            }
            self.tracklist?.insert(trackId, at: to)
            callback(true)
        }
    }
    
    public func remove(from: Int = 0, callback: @escaping (Bool) -> ()) {
        guard let keys = AuthManager.s.getAuthKeys(),
            let tracklist = self.tracklist,
            from <= tracklist.count - 1 else
        {
            callback(false)
            return
        }
        APIManager.s.tracklistRemove(keys: keys, from: from) { [weak self] error, status in
            guard let `self` = self else { return }
            if let _ = error {
                callback(false)
                return
            }
            self.tracklist?.remove(at: from)
            callback(true)
        }
    }
    
    public func move(from: Int = 0, to: Int = 0, callback: @escaping (Bool) -> ()) {
        guard let keys = AuthManager.s.getAuthKeys(),
            let tracklist = self.tracklist, from <= tracklist.count - 1,
            to <= tracklist.count else
        {
            callback(false)
            return
        }
        APIManager.s.tracklistMove(keys: keys, from: from, to: to) { [weak self] error, status in
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
