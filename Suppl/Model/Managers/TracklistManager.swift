import Foundation

final class TracklistManager {
    
    static public let s = TracklistManager()
    private init() {}
    
    private(set) var inUpdate: Bool = false
    private(set) var tracklist: [String]? {
        didSet {
            NotificationCenter.default.post(name: .TracklistUpdated, object: nil)
        }
    }
    
    public func update(callback: @escaping (Bool) -> ()) {
        if inUpdate { return }
        inUpdate = true
        guard let keys = AuthManager.s.getAuthKeys() else {
            sendCallbackStatus(false, callback: callback)
            return
        }
        APIManager.s.tracklistGet(keys: keys) { [weak self] error, data in
            guard let `self` = self else { return }
            if let error = error, error.domain == "music_tracklist_empty" {
                TracklistManager.s.tracklist = []
                self.sendCallbackStatus(false, callback: callback)
                return
            }
            guard let data = data else {
                self.sendCallbackStatus(false, callback: callback)
                return
            }
            self.tracklist = data.list
            self.sendCallbackStatus(true, callback: callback)
        }
    }
    
    public func add(trackId: String, to: Int = 0, callback: @escaping (Bool) -> ()) {
        guard let keys = AuthManager.s.getAuthKeys(), let tracklist = TracklistManager.s.tracklist else
        {
            sendCallbackStatus(false, callback: callback)
            return
        }
        if let _ = tracklist.index(of: trackId) {
            sendCallbackStatus(false, callback: callback)
            return
        }
        APIManager.s.tracklistAdd(keys: keys, trackID: trackId, to: to) { [weak self] error, status in
            guard let `self` = self else { return }
            if let _ = error {
                self.sendCallbackStatus(false, callback: callback)
                return
            }
            TracklistManager.s.tracklist?.insert(trackId, at: to)
            self.sendCallbackStatus(true, callback: callback)
        }
    }
    
    public func remove(from: Int = 0, callback: @escaping (Bool) -> ()) {
        guard let keys = AuthManager.s.getAuthKeys(),
            let tracklist = TracklistManager.s.tracklist,
            from <= tracklist.count - 1 else
        {
            sendCallbackStatus(false, callback: callback)
            return
        }
        APIManager.s.tracklistRemove(keys: keys, from: from) { [weak self] error, status in
            guard let `self` = self else { return }
            if let _ = error {
                self.sendCallbackStatus(false, callback: callback)
                return
            }
            TracklistManager.s.tracklist?.remove(at: from)
            self.sendCallbackStatus(true, callback: callback)
        }
    }
    
    public func move(from: Int = 0, to: Int = 0, callback: @escaping (Bool) -> ()) {
        guard let keys = AuthManager.s.getAuthKeys(),
            let tracklist = TracklistManager.s.tracklist, from <= tracklist.count - 1,
            to <= tracklist.count else
        {
            sendCallbackStatus(false, callback: callback)
            return
        }
        APIManager.s.tracklistMove(keys: keys, from: from, to: to) { [weak self] error, status in
            guard let `self` = self else { return }
            if let _ = error {
                self.sendCallbackStatus(false, callback: callback)
                return
            }
            var tracklistTemp = tracklist
            tracklistTemp.remove(at: from)
            tracklistTemp.insert(tracklist[from], at: to)
            TracklistManager.s.tracklist = tracklistTemp
            self.sendCallbackStatus(true, callback: callback)
        }
    }
    
    private func sendCallbackStatus(_ status: Bool, callback: @escaping (Bool) -> ()) {
        inUpdate = false
        callback(status)
    }
}

extension Notification.Name {
    static let TracklistUpdated = Notification.Name("TracklistUpdated")
}

