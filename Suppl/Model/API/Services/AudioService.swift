import Foundation

final class AudioService {
    
    public static func search(api: APIRequest, ikey: Int, akey: Int, query: String, offset: Int = 0, dataReport: @escaping (NSError?, AudioSearchData?) -> ()) {
        let query = UserService.queryWithAuth(ikey, akey, ["query": query, "offset": String(offset)])
        api.method("audio.search", query: query, dataReport: dataReport) { data in
            return data.data
        }
    }
    
    public static func get(api: APIRequest, ikey: Int, akey: Int, ids: String, dataReport: @escaping (NSError?, AudioListData?) -> ()) {
        let query = UserService.queryWithAuth(ikey, akey, ["ids": ids])
        api.method("audio.get", query: query, dataReport: dataReport) { data in
            return data.data
        }
    }
 
}
