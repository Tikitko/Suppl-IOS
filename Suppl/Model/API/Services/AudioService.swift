import Foundation

final class AudioService {
    
    public static func search(api: APIRequest, ikey: Int, akey: Int, query: String, offset: Int = 0, dataReport: @escaping (NSError?, AudioSearchData?) -> ()) {
        var query = ["method": "audio.search", "query": query, "offset": String(offset)]
        UserService.authPartAdd(query: &query, ikey, akey)
        api.method(query: query, dataReport: dataReport) { data in
            return AudioSearchData.parse(data)
        }
    }
    
    public static func get(api: APIRequest, ikey: Int, akey: Int, ids: String, dataReport: @escaping (NSError?, AudioListData?) -> ()) {
        var query = ["method": "audio.get", "ids": ids]
        UserService.authPartAdd(query: &query, ikey, akey)
        api.method(query: query, dataReport: dataReport) { data in
            return AudioListData.parse(data)
        }
    }
 
}
