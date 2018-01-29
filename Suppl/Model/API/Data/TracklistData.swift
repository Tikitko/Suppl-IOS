struct TracklistData: Codable {
    var list: [String]
    
    subscript(index: Int) -> String {
        get {
            return list[index]
        }
        set(newValue) {
            list[index] = newValue
        }
    }
}
