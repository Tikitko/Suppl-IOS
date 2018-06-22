import Foundation

final class APIManager {

    static public let s = APIManager()
    private init() {}
    
    public let user = UserService()
    public let audio = AudioService()
    public let tracklist = TracklistService()
    
}
