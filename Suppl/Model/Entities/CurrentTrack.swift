import Foundation
import UIKit
import MediaPlayer

struct CurrentTrack {
    let id: String
    let title: String
    let performer: String
    let duration: Int
    var image: UIImage?
    
    init(id: String, title: String, performer: String, duration: Int) {
        self.id = id
        self.title = title
        self.performer = performer
        self.duration = duration
    }
    
    // MPNowPlayingInfoCenter info
    var elapsedPlaybackTime: TimeInterval?
    var playbackRate: Double?
    var nowPlayingInfo: [String: Any] {
        var nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: title,
            MPMediaItemPropertyArtist: performer,
            MPMediaItemPropertyPlaybackDuration: duration
        ]
        if let image = image {
            let artwork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { _ in image })
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        }
        if let elapsedPlaybackTime = elapsedPlaybackTime {
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedPlaybackTime
        }
        if let playbackRate = playbackRate {
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate
        }
        return nowPlayingInfo
    }
}
