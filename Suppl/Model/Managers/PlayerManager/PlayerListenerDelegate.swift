import Foundation
import UIKit
import AVFoundation

protocol PlayerListenerDelegate: class {
    
    func playlistAdded(_ playlist: Playlist)
    func playlistRemoved()
    
    func itemReadyToPlay(_ item: AVPlayerItem)
    func itamTimeChanged(_ item: AVPlayerItem, _ sec: Double)
    
    func playerStop()
    func playerPlay()
    
    func trackInfoChanged(_ track: CurrentTrack, _ imageData: Data?)
    
}

extension PlayerListenerDelegate {
    
    func playlistAdded(_ playlist: Playlist) {}
    func playlistRemoved() {}
    
    func itemReadyToPlay(_ item: AVPlayerItem) {}
    func itamTimeChanged(_ item: AVPlayerItem, _ sec: Double) {}
    
    func playerStop() {}
    func playerPlay() {}
    
    func trackInfoChanged(_ track: CurrentTrack, _ imageData: Data?) {}
    
}

