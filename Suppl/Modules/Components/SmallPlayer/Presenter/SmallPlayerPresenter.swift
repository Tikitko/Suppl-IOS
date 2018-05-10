import Foundation

class SmallPlayerPresenter: SmallPlayerPresenterProtocol {
    
    var router: SmallPlayerRouterProtocol!
    var interactor: SmallPlayerInteractorProtocol!
    weak var view: SmallPlayerViewControllerProtocol!

    
    func showPlayer() {
        view.showPlayer()
    }
    
    func closePlayer() {
        view.closePlayer()
    }
    
    func setTrackInfo(title: String, performer: String) {
        view.setTrackInfo(title: title, performer: performer)
    }
    
    func setTrackImage(_ imageData: Data) {
        view.setTrackImage(imageData)
    }
    
    func openPlayer() {
        view.openPlayer()
    }
    
    func clearPlayer() {
        view.clearPlayer()
    }
    
    func updatePlayerProgress(percentages: Float) {
        view.updatePlayerProgress(percentages: percentages)
    }
    
    func navButtonClick(next: Bool) {
        interactor.navButtonClick(next: next)
    }
    
    func play() {
        interactor.play()
    }
    
    func rewindP() {
        interactor.rewindP()
    }
    
    func rewindM() {
        interactor.rewindP()
    }
    
    func setPlayImage() {
        view.setPlayImage()
    }
    
    func setPauseImage() {
        view.setPauseImage()
    }
    
    func openBigPlayer() {
        router.openBigPlayer()
    }
    
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool = false) {
        interactor.setPlayerCurrentTime(sec, withCurrentTime: withCurrentTime)
    }
    
    func removePlayer() {
        interactor.clearPlayer()
    }
    
}
