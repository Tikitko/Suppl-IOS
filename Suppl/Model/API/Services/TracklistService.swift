import Foundation

final class TracklistService {
    
    private let API = APISession()

    public func get(keys: KeysPair, completionHandler: @escaping (APISession.ResponseError?, TracklistData?) -> ()) {
        API.method(
            "tracklist.get",
            query: keys.addToQuery([:]),
            wrapper: { $0.data },
            completionHandler: completionHandler
        )
    }

    public func add(keys: KeysPair, trackID: String, to: Int = 0, completionHandler: @escaping (APISession.ResponseError?, Bool?) -> ()) {
        API.method(
            "tracklist.add",
            query: keys.addToQuery(["track_id": trackID, "to": String(to)]),
            wrapper: { $0.status == 1 },
            completionHandler: completionHandler
        )
    }
    
    public func remove(keys: KeysPair, from: Int = 0, completionHandler: @escaping (APISession.ResponseError?, Bool?) -> ()) {
        API.method(
            "tracklist.remove",
            query: keys.addToQuery(["from": String(from)]),
            wrapper: { $0.status == 1 },
            completionHandler: completionHandler
        )
    }
    
    public func move(keys: KeysPair, from: Int = 0, to: Int = 0, completionHandler: @escaping (APISession.ResponseError?, Bool?) -> ()) {
        API.method(
            "tracklist.move",
            query: keys.addToQuery(["from": String(from), "to": String(to)]),
            wrapper: { $0.status == 1 },
            completionHandler: completionHandler
        )
    }
    
}

