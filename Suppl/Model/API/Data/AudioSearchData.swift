import Foundation

struct AudioSearchData {
    var hasMore: Bool
    var nextOffset: Int
    var totalCount: Int
    var list: AudioListData
    
    static func parse(_ data: NSDictionary) -> AudioSearchData {
        let hasMore = data["hasMore"] as? Bool ?? false
        let nextOffset = data["nextOffset"] as? Int ?? -1
        let totalCount = data["totalCount"] as? Int ?? -1
        let list = AudioListData.parse(data)
        return AudioSearchData(hasMore: hasMore, nextOffset: nextOffset, totalCount: totalCount, list: list)
    }
}
