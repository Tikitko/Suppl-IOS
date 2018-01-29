struct AudioData: Codable {
    var id: String
    var track: String?
    var performer: String
    var title: String
    var duration: Int
    var images: [String]
}
