    import Foundation
    
    struct UserData {
        var id: Int
        var identifierKey: Int
        var email: String?
        
        
        static func parse(_ data: NSDictionary) -> UserData {
            let id = data["id"] as? Int ?? -1
            let identifierKey = data["identifier_key"] as? Int ?? -1
            let email = data["reset_email"] as? String
            return UserData(id: id, identifierKey: identifierKey, email: email)
        }
    }
