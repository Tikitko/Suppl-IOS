import Foundation
import UIKit
import AVFoundation

protocol PlayerListenerDelegate: class {
    
    func playlistChanged(_ playlist: Playlist?)
    func playlistAdded(_ playlist: Playlist)
    func playlistRemoved()
    func playlistTrackInserted(_ inserted: AudioData, _ at: Int, _ playlist: Playlist)
    func playlistTrackRemoved(_ removed: AudioData, _ at: Int, _ playlist: Playlist)
    
    func itemReadyToPlay(_ item: AVPlayerItem, _ duration: Int?)
    func itemTimeChanged(_ item: AVPlayerItem, _ sec: Double)
    
    func playerStop()
    func playerPlay()
    
    func trackInfoChanged(_ track: CurrentTrack, _ imageData: Data?)
    
}

extension PlayerListenerDelegate {
    
    func playlistChanged(_ playlist: Playlist?) {}
    func playlistAdded(_ playlist: Playlist) {}
    func playlistRemoved() {}
    func playlistTrackInserted(_ inserted: AudioData, _ at: Int, _ playlist: Playlist) {}
    func playlistTrackRemoved(_ removed: AudioData, _ at: Int, _ playlist: Playlist) {}
    
    func itemReadyToPlay(_ item: AVPlayerItem, _ duration: Int?) {}
    func itemTimeChanged(_ item: AVPlayerItem, _ sec: Double) {}
    
    func playerStop() {}
    func playerPlay() {}
    
    func trackInfoChanged(_ track: CurrentTrack, _ imageData: Data?) {}
    
}

