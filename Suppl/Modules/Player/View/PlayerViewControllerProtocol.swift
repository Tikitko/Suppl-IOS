import Foundation
import UIKit

protocol PlayerViewControllerProtocol: class {
    func setNavTitle(_ title: String)
    func loadNowTrack(track: CurrentTrack, playerRate: Float)
    func clearPlayer()
    func setTrackInfo(title: String, performer: String)
    func setTrackImage(_ imageData: Data)
    func updatePlayerProgress(currentTime: Double)
    func openPlayer(duration: Double)
    func setPlayImage()
    func setPauseImage() 
}
