import Foundation

struct AudioSearchData {
    var hasMore: Bool
    var nextOffset: Int
    var totalCount: Int
    var list: AudioListData
    
    static func parse(_ data: NSDictionary) -> AudioSearchData {
        let hasMore = data["has_more"] as? Bool ?? false
        let nextOffset = data["next_offset"] as? Int ?? -1
        let totalCount = data["total_count"] as? Int ?? -1
        let list = AudioListData.parse(data)
        return AudioSearchData(hasMore: hasMore, nextOffset: nextOffset, totalCount: totalCount, list: list)
    }
}
