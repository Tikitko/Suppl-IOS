import Foundation
import UIKit

protocol PlayerViewControllerProtocol: class {
    func setNavTitle(_ title: String)
    func clearPlayer()
    func setTrackInfo(title: String, performer: String)
    func setTrackImage(_ image: UIImage?)
    func setTrackImage(_ imageData: Data)
    func updatePlayerProgress(currentTime: Double)
    func openPlayer(duration: Double)
    func setPlayImage()
    func setPauseImage() 
}
