import Foundation

protocol SmallPlayerPresenterProtocol: class {
    func showPlayer()
    func closePlayer()
    func setTrackInfo(title: String, performer: String)
    func setTrackImage(_ imageData: Data)
    func clearPlayer()
    func updatePlayerProgress(percentages: Float)
    func openPlayer()
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool)
    func navButtonClick(next: Bool)
    func play()
    func rewindP()
    func rewindM()
    func setPlayImage()
    func setPauseImage()
    func openBigPlayer()
    func removePlayer()
}
