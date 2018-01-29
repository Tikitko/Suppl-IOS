import Foundation

struct TracklistData {
    var list: [String]
    
    static func parse(_ data: NSDictionary) -> TracklistData {
        let tempList = data["list"] as? [String] ?? []
        var list: [String] = []
        tempList.forEach { value in
            list.append(value)
        }
        return TracklistData(list: list)
    }
    
    subscript(index: Int) -> String {
        get {
            return list[index]
        }
        set(newValue) {
            list[index] = newValue
        }
    }
}
