import Foundation
import UIKit
import AVFoundation

class PlayerPresenter: PlayerPresenterProtocolInteractor, PlayerPresenterProtocolView {
    
    var router: PlayerRouterProtocol!
    var interactor: PlayerInteractorProtocol!
    weak var view: PlayerViewControllerProtocol!
    
    func setListener() {
        interactor.setPlayerListener(self)
    }
    
    func firstLoad() {
        interactor.loadNowTrack()
    }
    
    func navButtonClick(next: Bool) {
        next ? interactor.callNextTrack() : interactor.callPrevTrack()
    }
    
    func play() {
        interactor.play()
    }
    
    func rewindP() {
        interactor.setPlayerCurrentTime(15, withCurrentTime: true)
    }
    
    func rewindM() {
        interactor.setPlayerCurrentTime(-15, withCurrentTime: true)
    }

    func setPlayerCurrentTime(_ sec: Double, withCurrentTime: Bool = false) {
        interactor.setPlayerCurrentTime(sec, withCurrentTime: withCurrentTime)
    }
    
    func closePlayer() {
        router.closePlayer()
    }
    
    func setNowTrack(track: CurrentTrack, status: Float?, currentTime: Double?) {
        view.clearPlayer()
        view.setTrackInfo(title: track.title, performer: track.performer)
        view.setTrackImage(track.image)
        if let status = status, let currentTime = currentTime {
            view.openPlayer(duration: Double(track.duration))
            view.updatePlayerProgress(currentTime: currentTime)
            status == 1 ? view.setPauseImage() : view.setPlayImage()
        }
    }
    
    func updatePlayerProgress(currentTime: Double) {
        view.updatePlayerProgress(currentTime: currentTime)
    }
    
}

extension PlayerPresenter: PlayerListenerDelegate {
    
    func itemReadyToPlay(_ item: AVPlayerItem) {
        view.openPlayer(duration: item.duration.seconds)
    }
    
    func itamTimeChanged(_ item: AVPlayerItem, _ sec: Double) {
        view.updatePlayerProgress(currentTime: sec)
    }
    
    func playerStop() {
        view.setPlayImage()
    }
    
    func playerPlay() {
        view.setPauseImage()
    }
    
    func trackInfoChanged(_ track: CurrentTrack, _ imageData: Data?) {
        if let imageData = imageData {
            view.setTrackImage(imageData)
        } else {
            view.clearPlayer()
            view.setTrackInfo(title: track.title, performer: track.performer)
        }
    }
    
}
