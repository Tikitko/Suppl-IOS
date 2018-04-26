import Foundation
import UIKit

class PlayerPresenter: PlayerPresenterProtocol {
    var router: PlayerRouterProtocol!
    var interactor: PlayerInteractorProtocol!
    weak var view: PlayerViewControllerProtocol!
    
    func load() {
        view.setNavTitle(LocalesManager.s.get(.playerTitle))
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
    
    func setTrackImage(_ imageData: NSData) {
        guard let image = UIImage(data: imageData as Data) else { return }
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
        guard let _ = interactor.tracks else { return }
        interactor.loadTrackByID(next ? interactor.tracks!.next() : interactor.tracks!.prev())
    }
    
    func play() {
        interactor.play()
    }
    
    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool = false) {
        interactor.setPlayerCurrentTime(sec, withCurrentTime: withCurrentTime)
    }
    
}
