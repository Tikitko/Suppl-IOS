import Foundation

final class UserService {
    
    private let API = APIRequest()
    
    public func register(dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        API.method(
            "user.register",
            query: [:],
            dataReport: dataReport,
            externalMethod: { $0.data }
        )
    }
    
    public func get(keys: KeysPair, dataReport: @escaping (NSError?, UserData?) -> ()) {
        API.method(
            "user.get",
            query: keys.addToQuery([:]),
            dataReport: dataReport,
            externalMethod: { $0.data }
        )
    }
    
    public func updateEmail(keys: KeysPair, email: String, dataReport: @escaping (NSError?, Bool?) -> ()) {
        API.method(
            "user.updateEmail",
            query: keys.addToQuery(["reset_email": email]),
            dataReport: dataReport,
            externalMethod: { $0.status == 1 }
        )
    }
    
    public func sendResetKey(email: String, dataReport: @escaping (NSError?, Bool?) -> ()) {
        API.method(
            "user.sendResetKey",
            query: ["reset_email": email],
            dataReport: dataReport,
            externalMethod: { $0.status == 1 }
        )
    }
    
    public func reset(resetKey: String, dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        API.method(
            "user.reset",
            query: ["reset_key": resetKey],
            dataReport: dataReport,
            externalMethod: { $0.data }
        )
    }
    
}
