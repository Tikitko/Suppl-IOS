import Foundation

final class TracklistService {
    
    func get(api: APIRequest, keys: KeysPair, dataReport: @escaping (NSError?, TracklistData?) -> ()) {
        let query = keys.addToQuery([:])
        api.method("tracklist.get", query: query, dataReport: dataReport) { data in
            return data.data
        }
    }

    func add(api: APIRequest, keys: KeysPair, trackID: String, to: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = keys.addToQuery(["track_id": trackID, "to": String(to)])
        api.method("tracklist.add", query: query, dataReport: dataReport) { data in
            return data.status == 1
        }
    }
    
    func remove(api: APIRequest, keys: KeysPair, from: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = keys.addToQuery(["from": String(from)])
        api.method("tracklist.remove", query: query, dataReport: dataReport) { data in
            return data.status == 1
        }
    }
    
    func move(api: APIRequest, keys: KeysPair, from: Int = 0, to: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = keys.addToQuery(["from": String(from), "to": String(to)])
        api.method("tracklist.move", query: query, dataReport: dataReport) { data in
            return data.status == 1
        }
    }
}

