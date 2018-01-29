import Foundation

final class TracklistService {
    
    public static func get(api: APIRequest, ikey: Int, akey: Int, dataReport: @escaping (NSError?, TracklistData?) -> ()) {
        let query = UserService.queryWithAuth(ikey, akey)
        api.method("tracklist.get", query: query, dataReport: dataReport) { data in
            return data.data
        }
    }

    public static func add(api: APIRequest, ikey: Int, akey: Int, trackID: String, to: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = UserService.queryWithAuth(ikey, akey, ["track_id": trackID, "to": String(to)])
        api.method("tracklist.add", query: query, dataReport: dataReport) { data in
            return data.status == 1
        }
    }
    
    public static func remove(api: APIRequest, ikey: Int, akey: Int, from: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = UserService.queryWithAuth(ikey, akey, ["from": String(from)])
        api.method("tracklist.remove", query: query, dataReport: dataReport) { data in
            return data.status == 1
        }
    }
    
    public static func move(api: APIRequest, ikey: Int, akey: Int, from: Int = 0, to: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = UserService.queryWithAuth(ikey, akey, ["from": String(from), "to": String(to)])
        api.method("tracklist.move", query: query, dataReport: dataReport) { data in
            return data.status == 1
        }
    }
}

