import Foundation

final class AudioService {
    
    private let API = APISession()
    
    public func search(keys: KeysPair, query: String, offset: Int = 0, completionHandler: @escaping (APISession.ResponseError?, AudioSearchData?) -> ()) {
        API.method(
            "audio.search",
            query: keys.addToQuery(["query": query, "offset": String(offset)]),
            wrapper: { $0.data },
            completionHandler: completionHandler
        )
    }
    
    public func get(keys: KeysPair, ids: [String], completionHandler: @escaping (APISession.ResponseError?, AudioListData?) -> ()) {
        API.method(
            "audio.get",
            query: keys.addToQuery(["ids": ids.joined(separator: ",")]),
            wrapper: { $0.data },
            completionHandler: completionHandler
        )
    }
 
}
