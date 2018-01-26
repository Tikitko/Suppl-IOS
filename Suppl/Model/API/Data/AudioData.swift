import Foundation

struct AudioData {
    var id: String
    var track: String?
    var performer: String
    var title: String
    var duration: Int
    var images: [String]

    
    static func parse(_ data: NSDictionary) -> AudioData {
        let id = data["id"] as? String ?? String()
        let track = data["track"] as? String
        let performer = data["performer"] as? String ?? String()
        let title = data["title"] as? String ?? String()
        let duration = data["duration"] as? Int ?? -1
        let images = data["images"] as? [String] ?? []
        return AudioData(id: id, track: track, performer: performer, title: title, duration: duration, images: images)
    }
}
