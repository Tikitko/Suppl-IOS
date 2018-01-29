struct UserSecretData: Codable {
    var id: Int
    var identifierKey: Int
    var accessKey: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case identifierKey = "identifier_key"
        case accessKey = "access_key"
    }
}
