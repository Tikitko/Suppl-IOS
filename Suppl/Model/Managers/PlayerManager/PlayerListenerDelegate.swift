import Foundation
import UIKit

protocol PlayerListenerDelegate: class {
    
    func playlistAdded(_ playlist: Playlist)
    func playlistRemoved()
    
    func readyToPlay()
    
    func curentTrackTime(sec: Double)
    
    func playerStop()
    func playerPlay()
    
    func trackInfoChanged(_ track: CurrentTrack)
    func trackImageChanged(_ imageData: Data)
    
}

extension PlayerListenerDelegate {
    
    func playlistAdded(_ playlist: Playlist) {}
    func playlistRemoved() {}
    
    func readyToPlay() {}
    
    func curentTrackTime(sec: Double) {}
    
    func playerStop() {}
    func playerPlay() {}
    
    func trackInfoChanged(_ track: CurrentTrack) {}
    func trackImageChanged(_ imageData: Data) {}
    
}
