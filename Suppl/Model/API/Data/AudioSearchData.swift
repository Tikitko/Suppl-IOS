struct AudioSearchData: Codable {
    var hasMore: Bool
    var nextOffset: Int
    var totalCount: Int
    var list: [AudioData]
    
    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case nextOffset = "next_offset"
        case totalCount = "total_count"
        case list
    }
}
