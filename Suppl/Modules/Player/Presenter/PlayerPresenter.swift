import Foundation
import UIKit

class PlayerPresenter: PlayerPresenterProtocol {
    
    var router: PlayerRouterProtocol!
    var interactor: PlayerInteractorProtocol!
    weak var view: PlayerViewControllerProtocol!
    
    func load() {
        interactor.load()
    }
    
    func setNavTitle(_ title: String) {
        view.setNavTitle(title)
    }
        
    func setTrackInfo(title: String, performer: String) {
        view.setTrackInfo(title: title, performer: performer)
    }
    
    func setTrackImage(_ imageData: Data) {
        view.setTrackImage(imageData)
    }
    
    func openPlayer(duration: Double) {
        view.openPlayer(duration: duration)
    }
    
    func clearPlayer() {
        view.clearPlayer()
    }
    
    func updatePlayerProgress(currentTime: Double) {
        view.updatePlayerProgress(currentTime: currentTime)
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

    
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool = false) {
        interactor.setPlayerCurrentTime(sec, withCurrentTime: withCurrentTime)
    }
    
}
