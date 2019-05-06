import Foundation

final class AudioService {
    
    private let API = APISession()
    
    public func search(keys: KeysPair, query: String, offset: Int = 0, dataReport: @escaping (NSError?, AudioSearchData?) -> ()) {
        API.method(
            "audio.search",
            query: keys.addToQuery(["query": query, "offset": String(offset)]),
            dataReport: dataReport,
            externalMethod: { $0.data }
        )
    }
    
    public func get(keys: KeysPair, ids: [String], dataReport: @escaping (NSError?, AudioListData?) -> ()) {
        API.method(
            "audio.get",
            query: keys.addToQuery(["ids": ids.joined(separator: ",")]),
            dataReport: dataReport,
            externalMethod: { $0.data }
        )
    }
 
}
