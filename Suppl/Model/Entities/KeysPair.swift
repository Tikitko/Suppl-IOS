import Foundation

struct KeysPair {

    let identifierKey: Int
    let accessKey: Int
    
    var string: String {
        get { return "\(identifierKey)\(accessKey)" }
    }
    
    init(_ identifierKey: Int, _ accessKey: Int) {
        self.identifierKey = identifierKey
        self.accessKey = accessKey
    }
    
    func addToQuery(_ query: inout Dictionary<String, String>) {
        query["identifier_key"] = String(identifierKey)
        query["access_key"] = String(accessKey)
    }
    
    func addToQuery(_ query: Dictionary<String, String>) -> Dictionary<String, String> {
        var tempQuery = query
        addToQuery(&tempQuery)
        return tempQuery
    }
    
}
