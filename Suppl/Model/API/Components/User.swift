import Foundation

final class User {
    
    public static func get(api: APIRequest, ikey: Int, akey: Int, dataReport: @escaping (NSError?, UserData?) -> ()) {
        var query = ["method": "user.get"]
        authPartAdd(query: &query, ikey, akey)
        api.request(query: query) { error, data in
            if let error = error {
                print(error)
            } else if let data = data {
                print(data.status)
                print(data.errorDescription)
                //print(data.data)
            }

        }
    }
    
    /*public static func register(api: API, dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        let query = ["method": "user.register"]
        api.method(query: query, dataReport: dataReport) { data in
            return UserSecretData.parse(data)
        }
    }
    
    public static func get(api: API, ikey: Int, akey: Int, dataReport: @escaping (NSError?, UserData?) -> ()) {
        var query = ["method": "user.get"]
        authPartAdd(query: &query, ikey, akey)
        api.method(query: query, dataReport: dataReport) { data in
            return UserData.parse(data)
        }
    }*/
    
    public static func authPartAdd(query: inout Dictionary<String, String>, _ ikey: Int, _ akey: Int) -> Void {
        query["identifier_key"] = String(ikey)
        query["access_key"] = String(akey)
    }
}


