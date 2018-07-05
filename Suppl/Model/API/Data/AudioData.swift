struct AudioData: Codable {
    var id: String
    var track: String?
    var performer: String
    var title: String
    var duration: Int
    var images: [String]
    
    init(track: Track) {
        id = track.id as String
        self.track = nil
        performer = track.performer as String
        title = track.title as String
        duration = track.duration.intValue
        images = track.imageLink != nil ? [track.imageLink! as String] : []
    }
}
