import Foundation
import UIKit

class PlayerPresenter: PlayerPresenterProtocol {
    var router: PlayerRouterProtocol!
    var interactor: PlayerInteractorProtocol!
    weak var view: PlayerViewControllerProtocol!
    
    func load() {
        view.setNavTitle("Плеер")
        clearPlayer()
        guard let tracks = interactor.tracks else { return }
        interactor.loadTrackByID(tracks.curr())
    }
    
    func show() {}
    
    func setTrackInfo(title: String, performer: String) {
        view.setTrackInfo(title: title, performer: performer)
    }
    
    func setTrackImage(_ image: UIImage) {
        view.setTrackImage(image)
    }
    
    func clearPlayer() {
        interactor.needPlayingStatus = false
        stopObservers()
        interactor.clearPlayer()
        view.clearPlayerForm()
    }
    
    func startObservers() {
        interactor.addPlayStatusObserver()
        interactor.addPlayerRateObserver()
    }
    
    func stopObservers() {
        interactor.removePlayStatusObserver()
        interactor.removePlayerRateObserver()
    }
    
    func updatePlayerProgress(currentTime: Double) {
        view.updatePlayerProgress(currentTime: currentTime)
    }
    
    func addPlayerTimeObserver() {
        interactor.addPlayerTimeObserver()
    }
    
    func openPlayer(duration: Double) {
        view.openPlayer(duration: duration)
    }
    
    func setPlayButtonImage(_ image: UIImage) {
        view.setPlayButtonImage(image)
    }
    
    func navButtonClick(next: Bool) {
        guard let tracks = interactor.tracks else { return }
        interactor.loadTrackByID(next ? tracks.next() : tracks.prev())
    }
    
    func play() {
        interactor.play()
    }
    
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool = false) {
        interactor.setPlayerCurrentTime(sec, withCurrentTime: withCurrentTime)
    }
    
}
