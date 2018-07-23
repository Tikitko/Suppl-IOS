import Foundation

final class TracklistService {
    
    private let API = APIRequest()

    public func get(keys: KeysPair, dataReport: @escaping (NSError?, TracklistData?) -> ()) {
        API.method(
            "tracklist.get",
            query: keys.addToQuery([:]),
            dataReport: dataReport,
            externalMethod: { $0.data }
        )
    }

    public func add(keys: KeysPair, trackID: String, to: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        API.method(
            "tracklist.add",
            query: keys.addToQuery(["track_id": trackID, "to": String(to)]),
            dataReport: dataReport,
            externalMethod: { $0.status == 1 }
        )
    }
    
    public func remove(keys: KeysPair, from: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        API.method(
            "tracklist.remove",
            query: keys.addToQuery(["from": String(from)]),
            dataReport: dataReport,
            externalMethod: { $0.status == 1 }
        )
    }
    
    public func move(keys: KeysPair, from: Int = 0, to: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        API.method(
            "tracklist.move",
            query: keys.addToQuery(["from": String(from), "to": String(to)]),
            dataReport: dataReport,
            externalMethod: { $0.status == 1 }
        )
    }
    
}

