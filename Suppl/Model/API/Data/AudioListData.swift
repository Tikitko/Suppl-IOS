struct AudioListData: Codable {
    var list: [AudioData]
    
    subscript(index: Int) -> AudioData {
        get {
            return list[index]
        }
        set(newValue) {
            list[index] = newValue
        }
    }
}
