import Foundation
import AVFoundation
import AVKit
import MediaPlayer
import UIKit

protocol PlayerInteractorProtocol: class {
    
    var needPlayingStatus: Bool { get set }
    var tracks: PlayerInteractor.TracksList? { get set }
    
    func loadTrackByID(_ trackID: String)
    func clearPlayer()
    func setPlayingStatus(_ status: Bool)
    func addPlayStatusObserver()
    func removePlayStatusObserver()
    func addPlayerRateObserver()
    func removePlayerRateObserver()
    func addPlayerTimeObserver()
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func play()
}