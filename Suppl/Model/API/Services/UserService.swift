import Foundation

final class UserService {
    
    /*public static func get(api: APIRequest, ikey: Int, akey: Int, dataReport: @escaping (NSError?, UserData?) -> ()) {
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
    }*/
    
    public static func register(api: APIRequest, dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        let query = ["method": "user.register"]
        api.method(query: query, dataReport: dataReport) { data in
            return UserSecretData.parse(data)
        }
    }
    
    public static func get(api: APIRequest, ikey: Int, akey: Int, dataReport: @escaping (NSError?, UserData?) -> ()) {
        let query = queryWithAuth(ikey, akey, ["method": "user.get"])
        api.method(query: query, dataReport: dataReport) { data in
            return UserData.parse(data)
        }
    }
    
    public static func updateEmail(api: APIRequest, ikey: Int, akey: Int, email: String, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = queryWithAuth(ikey, akey, ["method": "user.updateEmail", "reset_email": email])
        api.method(query: query, dataReport: dataReport) { data in
            return data.count == 0
        }
    }
    
    public static func sendResetKey(api: APIRequest, email: String, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = ["method": "user.sendResetKey", "reset_email": email]
        api.method(query: query, dataReport: dataReport) { data in
            return data.count == 0
        }
    }
    
    public static func reset(api: APIRequest, resetKey: String, dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        let query = ["method": "user.reset", "reset_key": resetKey]
        api.method(query: query, dataReport: dataReport) { data in
            return UserSecretData.parse(data)
        }
    }
    
    public static func queryWithAuth(_ ikey: Int, _ akey: Int, _ query: Dictionary<String, String> = [:]) -> Dictionary<String, String> {
        var query: Dictionary<String, String> = query
        query["identifier_key"] = String(ikey)
        query["access_key"] = String(akey)
        return query
    }
}


