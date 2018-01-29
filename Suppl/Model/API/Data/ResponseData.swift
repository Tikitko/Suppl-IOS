struct ResponseData<T: Codable>: Codable {
    var status: Int
    var errorID: Int?
    var errorDesc: String?
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case status
        case errorID = "error_id"
        case errorDesc = "error_description"
        case data
    }
}
