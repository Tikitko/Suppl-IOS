import Foundation

protocol SmallPlayerViewControllerProtocol: class {
    func setPlayerShowAnimated(type: SmallPlayerViewController.ShowType)
    func clearPlayer()
    func setTrackInfo(title: String, performer: String)
    func setTrackImage(_ imageData: Data)
    func updatePlayerProgress(percentages: Float, currentTime: Double)
    func openPlayer(duration: Double)
    func setPlayImage()
    func setPauseImage() 
}
