import Foundation

final class TracklistService {
    
    private let API = APIRequest()

    public func get(keys: KeysPair, dataReport: @escaping (NSError?, TracklistData?) -> ()) {
        let query = keys.addToQuery([:])
        API.method("tracklist.get", query: query, dataReport: dataReport) { data in
            return data.data
        }
    }

    public func add(keys: KeysPair, trackID: String, to: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = keys.addToQuery(["track_id": trackID, "to": String(to)])
        API.method("tracklist.add", query: query, dataReport: dataReport) { data in
            return data.status == 1
        }
    }
    
    public func remove(keys: KeysPair, from: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = keys.addToQuery(["from": String(from)])
        API.method("tracklist.remove", query: query, dataReport: dataReport) { data in
            return data.status == 1
        }
    }
    
    public func move(keys: KeysPair, from: Int = 0, to: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = keys.addToQuery(["from": String(from), "to": String(to)])
        API.method("tracklist.move", query: query, dataReport: dataReport) { data in
            return data.status == 1
        }
    }
    
}

