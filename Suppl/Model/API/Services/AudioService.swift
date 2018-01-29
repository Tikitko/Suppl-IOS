import Foundation

final class AudioService {
    
    public static func search(api: APIRequest, ikey: Int, akey: Int, query: String, offset: Int = 0, dataReport: @escaping (NSError?, AudioSearchData?) -> ()) {
        let query = UserService.queryWithAuth(ikey, akey, ["method": "audio.search", "query": query, "offset": String(offset)])
        api.method(query: query, dataReport: dataReport) { data in
            return AudioSearchData.parse(data)
        }
    }
    
    public static func get(api: APIRequest, ikey: Int, akey: Int, ids: String, dataReport: @escaping (NSError?, AudioListData?) -> ()) {
        let query = UserService.queryWithAuth(ikey, akey, ["method": "audio.get", "ids": ids])
        api.method(query: query, dataReport: dataReport) { data in
            return AudioListData.parse(data)
        }
    }
 
}
