import Foundation

final class UserService {
    
    private let API = APISession()
    
    public func register(completionHandler: @escaping (APISession.ResponseError?, UserSecretData?) -> ()) {
        API.method(
            "user.register",
            query: [:],
            wrapper: { $0.data },
            completionHandler: completionHandler
        )
    }
    
    public func get(keys: KeysPair, completionHandler: @escaping (APISession.ResponseError?, UserData?) -> ()) {
        API.method(
            "user.get",
            query: keys.addToQuery([:]),
            wrapper: { $0.data },
            completionHandler: completionHandler
        )
    }
    
    public func updateEmail(keys: KeysPair, email: String, completionHandler: @escaping (APISession.ResponseError?, Bool?) -> ()) {
        API.method(
            "user.updateEmail",
            query: keys.addToQuery(["reset_email": email]),
            wrapper: { $0.status == 1 },
            completionHandler: completionHandler
        )
    }
    
    public func sendResetKey(email: String, completionHandler: @escaping (APISession.ResponseError?, Bool?) -> ()) {
        API.method(
            "user.sendResetKey",
            query: ["reset_email": email],
            wrapper: { $0.status == 1 },
            completionHandler: completionHandler
        )
    }
    
    public func reset(resetKey: String, completionHandler: @escaping (APISession.ResponseError?, UserSecretData?) -> ()) {
        API.method(
            "user.reset",
            query: ["reset_key": resetKey],
            wrapper: { $0.data },
            completionHandler: completionHandler
        )
    }
    
}
