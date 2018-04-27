import Foundation

final class UserService {
    
    private let API = APIRequest()
    
    public func register(dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        API.method("user.register", query: [:], dataReport: dataReport) { data in
            return data.data
        }
    }
    
    public func get(keys: KeysPair, dataReport: @escaping (NSError?, UserData?) -> ()) {
        let query = keys.addToQuery([:])
        API.method("user.get", query: query, dataReport: dataReport) { data in
            return data.data
        }
    }
    
    public func updateEmail(keys: KeysPair, email: String, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = keys.addToQuery(["reset_email": email])
        API.method("user.updateEmail", query: query, dataReport: dataReport) { data in
            return data.status == 1
        }
    }
    
    public func sendResetKey(email: String, dataReport: @escaping (NSError?, Bool?) -> ()) {
        let query = ["reset_email": email]
        API.method("user.sendResetKey", query: query, dataReport: dataReport) { data in
            return data.status == 1
        }
    }
    
    public func reset(resetKey: String, dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        let query = ["reset_key": resetKey]
        API.method("user.reset", query: query, dataReport: dataReport) { data in
            return data.data
        }
    }
    
}
