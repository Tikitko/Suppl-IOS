import Foundation

struct AudioListData {
    var list: [AudioData]
    
    static func parse(_ data: NSDictionary) -> AudioListData {
        let tempList = data["list"] as? [NSDictionary] ?? []
        var list: [AudioData] = []
        tempList.forEach { value in
            list.append(AudioData.parse(value))
        }
        return AudioListData(list: list)
    }
    
    subscript(index: Int) -> AudioData {
        get {
            return list[index]
        }
        set(newValue) {
            list[index] = newValue
        }
    }
}
