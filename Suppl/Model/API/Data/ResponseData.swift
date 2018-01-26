import Foundation

struct ResponseData: Codable{
    var status: Int
    var data: Dictionary<String, String>?
    var errorID: Int?
    var errorDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case errorID = "error_id"
        case errorDescription = "error_description"
    }
}
