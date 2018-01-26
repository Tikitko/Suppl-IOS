    import Foundation

    struct UserSecretData {
        var id: Int
        var identifierKey: Int
        var accessKey: Int

        static func parse(_ data: NSDictionary) -> UserSecretData {
            let id = data["id"] as? Int ?? -1
            let identifierKey = data["identifier_key"] as? Int ?? -1
            let accessKey = data["access_key"] as? Int ?? -1
            return UserSecretData(id: id, identifierKey: identifierKey, accessKey: accessKey)
        }
    }
