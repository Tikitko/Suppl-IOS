import Foundation

final class TracklistService {
    
    public static func get(api: APIRequest, ikey: Int, akey: Int, dataReport: @escaping (NSError?, TracklistData?) -> ()) {
        let query = UserService.queryWithAuth(ikey, akey, ["method": "tracklist.get"])
        api.method(query: query, dataReport: dataReport) { data in
            return TracklistData.parse(data)
        }
    }

    public static func add(api: APIRequest, ikey: Int, akey: Int, trackID: String, to: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = UserService.queryWithAuth(ikey, akey, ["method": "tracklist.add", "track_id": trackID, "to": String(to)])
        api.method(query: query, dataReport: dataReport) { data in
            return data.count == 0
        }
    }
    
    public static func remove(api: APIRequest, ikey: Int, akey: Int, from: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = UserService.queryWithAuth(ikey, akey, ["method": "tracklist.remove", "from": String(from)])
        api.method(query: query, dataReport: dataReport) { data in
            return data.count == 0
        }
    }
    
    public static func move(api: APIRequest, ikey: Int, akey: Int, from: Int = 0, to: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = UserService.queryWithAuth(ikey, akey, ["method": "tracklist.move", "from": String(from), "to": String(to)])
        api.method(query: query, dataReport: dataReport) { data in
            return data.count == 0
        }
    }
}

