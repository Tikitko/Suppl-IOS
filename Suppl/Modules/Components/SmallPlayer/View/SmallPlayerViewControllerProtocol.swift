import Foundation
import UIKit

protocol SmallPlayerViewControllerProtocol: class {
    func setPlayerShowAnimated(type: SmallPlayerViewController.ShowType)
    func updateAfterAnimation(block: @escaping (UIViewControllerTransitionCoordinatorContext?) -> Void)
    func clearPlayer()
    func setTrackInfo(title: String, performer: String)
    func setTrackImage(_ imageData: Data)
    func updatePlayerProgress(percentages: Float, currentTime: Double)
    func openPlayer(duration: Double)
    func setPlayImage()
    func setPauseImage() 
}
