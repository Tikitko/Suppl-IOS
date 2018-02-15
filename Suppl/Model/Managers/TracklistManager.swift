import Foundation

class TracklistManager {
    
    private(set) static var inUpdate: Bool = false
    private(set) static var tracklist: [String]? = nil {
        didSet {
            NotificationCenter.default.post(name: .TracklistUpdated, object: nil)
        }
    }
    
    public static func update(callback: @escaping (Bool) -> ()) {
        if inUpdate { return }
        inUpdate = true
        guard let ikey = UserDefaultsManager.identifierKey, let akey = UserDefaultsManager.accessKey else {
            sendCallbackStatus(false, callback: callback)
            return
        }
        APIManager.tracklistGet(ikey: ikey, akey: akey) { error, data in
            if let error = error, error.domain == "music_tracklist_empty" {
                TracklistManager.tracklist = []
                sendCallbackStatus(false, callback: callback)
                return
            }
            guard let data = data else {
                sendCallbackStatus(false, callback: callback)
                return
            }
            tracklist = data.list
            sendCallbackStatus(true, callback: callback)
        }
    }
    
    public static func add(trackId: String, to: Int = 0, callback: @escaping (Bool) -> ()) {
        guard let (ikey, akey) = AuthManager.getAuthKeys(),
            let tracklist = TracklistManager.tracklist else
        {
            sendCallbackStatus(false, callback: callback)
            return
        }
        if let _ = tracklist.index(of: trackId) {
            sendCallbackStatus(false, callback: callback)
            return
        }
        APIManager.tracklistAdd(ikey: ikey, akey: akey, trackID: trackId, to: to) { error, status in
            if let _ = error {
                sendCallbackStatus(false, callback: callback)
                return
            }
            TracklistManager.tracklist?.insert(trackId, at: to)
            sendCallbackStatus(true, callback: callback)
        }
    }
    
    public static func remove(from: Int = 0, callback: @escaping (Bool) -> ()) {
        guard let (ikey, akey) = AuthManager.getAuthKeys(),
            let tracklist = TracklistManager.tracklist,
            from <= tracklist.count - 1 else
        {
            sendCallbackStatus(false, callback: callback)
            return
        }
        APIManager.tracklistRemove(ikey: ikey, akey: akey, from: from) { error, status in
            if let _ = error {
                sendCallbackStatus(false, callback: callback)
                return
            }
            TracklistManager.tracklist?.remove(at: from)
            sendCallbackStatus(true, callback: callback)
        }
    }
    
    public static func move(from: Int = 0, to: Int = 0, callback: @escaping (Bool) -> ()) {
        guard let (ikey, akey) = AuthManager.getAuthKeys(),
            let tracklist = TracklistManager.tracklist, from <= tracklist.count - 1,
            to <= tracklist.count else
        {
            sendCallbackStatus(false, callback: callback)
            return
        }
        APIManager.tracklistMove(ikey: ikey, akey: akey, from: from, to: to) { error, status in
            if let _ = error {
                sendCallbackStatus(false, callback: callback)
                return
            }
            var tracklistTemp = tracklist
            tracklistTemp.remove(at: from)
            tracklistTemp.insert(tracklist[from], at: to)
            TracklistManager.tracklist = tracklistTemp
            sendCallbackStatus(true, callback: callback)
        }
    }
    
    private static func sendCallbackStatus(_ status: Bool ,callback: @escaping (Bool) -> ()) {
        inUpdate = false
        callback(status)
    }
}

extension Notification.Name {
    static let TracklistUpdated = Notification.Name("TracklistUpdated")
}
