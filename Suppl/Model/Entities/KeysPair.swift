import Foundation

struct KeysPair {
    
    let identifierKey: Int
    var i: Int {
        get { return identifierKey }
    }
    
    let accessKey: Int
    var a: Int {
        get { return accessKey }
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
        tempQuery["identifier_key"] = String(identifierKey)
        tempQuery["access_key"] = String(accessKey)
        return tempQuery
    }

    
}
