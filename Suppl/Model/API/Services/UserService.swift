import Foundation

final class UserService {
    
    public static func register(api: APIRequest, dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        api.method("user.register", query: [:], dataReport: dataReport) { data in
            return data.data
        }
    }
    
    public static func get(api: APIRequest, ikey: Int, akey: Int, dataReport: @escaping (NSError?, UserData?) -> ()) {
        let query = queryWithAuth(ikey, akey)
        api.method("user.get", query: query, dataReport: dataReport) { data in
            return data.data
        }
    }
    
    public static func updateEmail(api: APIRequest, ikey: Int, akey: Int, email: String, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = queryWithAuth(ikey, akey, ["reset_email": email])
        api.method("user.updateEmail", query: query, dataReport: dataReport) { data in
            return data.status == 1
        }
    }
    
    public static func sendResetKey(api: APIRequest, email: String, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = ["reset_email": email]
        api.method("user.sendResetKey", query: query, dataReport: dataReport) { data in
            return data.status == 1
        }
    }
    
    public static func reset(api: APIRequest, resetKey: String, dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        let query = ["reset_key": resetKey]
        api.method("user.reset", query: query, dataReport: dataReport) { data in
            return data.data
        }
    }
    
    public static func queryWithAuth(_ ikey: Int, _ akey: Int, _ query: Dictionary<String, String> = [:]) -> Dictionary<String, String> {
        var query: Dictionary<String, String> = query
        query["identifier_key"] = String(ikey)
        query["access_key"] = String(akey)
        return query
    }
    
}
