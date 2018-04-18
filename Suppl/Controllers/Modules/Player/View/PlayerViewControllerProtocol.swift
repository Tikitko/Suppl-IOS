import Foundation
import UIKit

protocol PlayerViewControllerProtocol: class {
    func setNavTitle(_ title: String)
    func clearPlayerForm()
    func setTrackInfo(title: String, performer: String)
    func setTrackImage(_ image: UIImage)
    func updatePlayerProgress(currentTime: Double)
    func openPlayer(duration: Double)
    func setPlayButtonImage(_ image: UIImage)
}
