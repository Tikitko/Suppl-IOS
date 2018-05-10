import Foundation

protocol SmallPlayerViewControllerProtocol: class {
    func showPlayer()
    func closePlayer()
    func clearPlayer()
    func setTrackInfo(title: String, performer: String)
    func setTrackImage(_ imageData: Data)
    func updatePlayerProgress(percentages: Float)
    func openPlayer()
    func setPlayImage()
    func setPauseImage() 
}
