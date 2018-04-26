import Foundation

final class AudioService {
    
    func search(api: APIRequest, keys: KeysPair, query: String, offset: Int = 0, dataReport: @escaping (NSError?, AudioSearchData?) -> ()) {
        let query = keys.addToQuery(["query": query, "offset": String(offset)])
        api.method("audio.search", query: query, dataReport: dataReport) { data in
            return data.data
        }
    }
    
    func get(api: APIRequest, keys: KeysPair, ids: String, dataReport: @escaping (NSError?, AudioListData?) -> ()) {
        let query = keys.addToQuery(["ids": ids])
        api.method("audio.get", query: query, dataReport: dataReport) { data in
            return data.data
        }
    }
 
}
