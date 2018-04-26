import Foundation

final class UserService {
    
    func register(api: APIRequest, dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        api.method("user.register", query: [:], dataReport: dataReport) { data in
            return data.data
        }
    }
    
    func get(api: APIRequest, keys: KeysPair, dataReport: @escaping (NSError?, UserData?) -> ()) {
        let query = keys.addToQuery([:])
        api.method("user.get", query: query, dataReport: dataReport) { data in
            return data.data
        }
    }
    
    func updateEmail(api: APIRequest, keys: KeysPair, email: String, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = keys.addToQuery(["reset_email": email])
        api.method("user.updateEmail", query: query, dataReport: dataReport) { data in
            return data.status == 1
        }
    }
    
    func sendResetKey(api: APIRequest, email: String, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = ["reset_email": email]
        api.method("user.sendResetKey", query: query, dataReport: dataReport) { data in
            return data.status == 1
        }
    }
    
    func reset(api: APIRequest, resetKey: String, dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        let query = ["reset_key": resetKey]
        api.method("user.reset", query: query, dataReport: dataReport) { data in
            return data.data
        }
    }
    
}
