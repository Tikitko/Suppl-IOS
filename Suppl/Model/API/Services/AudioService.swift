import Foundation

final class AudioService {
    
    private let API = APIRequest()
    
    public func search(keys: KeysPair, query: String, offset: Int = 0, dataReport: @escaping (NSError?, AudioSearchData?) -> ()) {
        let query = keys.addToQuery(["query": query, "offset": String(offset)])
        API.method("audio.search", query: query, dataReport: dataReport) { data in
            return data.data
        }
    }
    
    public func get(keys: KeysPair, ids: String, dataReport: @escaping (NSError?, AudioListData?) -> ()) {
        let query = keys.addToQuery(["ids": ids])
        API.method("audio.get", query: query, dataReport: dataReport) { data in
            return data.data
        }
    }
 
}
