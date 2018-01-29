struct UserData: Codable {
    var id: Int
    var identifierKey: Int
    var email: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case identifierKey = "identifier_key"
        case email = "reset_email"
    }
}
