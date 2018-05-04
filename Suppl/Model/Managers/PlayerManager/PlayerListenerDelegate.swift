import Foundation
import UIKit

protocol PlayerListenerDelegate: class {
    
    func playlistAdded(_ playlist: Playlist)
    func playlistRemoved()
    
    func blockControl()
    func openControl()
    
    func curentTrackTime(sec: Double)
    
    func playerStop()
    func playerPlay()
    
    func trackInfoChanged(_ track: CurrentTrack)
    func trackImageChanged(_ imageData: Data)
    
}
