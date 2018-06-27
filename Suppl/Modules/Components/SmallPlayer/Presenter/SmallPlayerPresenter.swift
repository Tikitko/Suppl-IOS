import Foundation
import UIKit
import AVFoundation

class SmallPlayerPresenter: SmallPlayerPresenterProtocolInteractor, SmallPlayerPresenterProtocolView {
    
    var router: SmallPlayerRouterProtocol!
    var interactor: SmallPlayerInteractorProtocol!
    weak var view: SmallPlayerViewControllerProtocol!
    
    func setListener() {
        interactor.setPlayerListener(self)
    }
    
    func getTitle() -> String {
        return interactor.getLocaleString(.playerTitle)
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

extension SmallPlayerPresenter: PlayerListenerDelegate {
    
    func playlistAdded(_ playlist: Playlist) {
        view.setPlayerShowAnimated(type: .partOpened)
    }
    
    func playlistRemoved() {
        view.setPlayerShowAnimated(type: .closed)
    }
    
    func itemReadyToPlay(_ item: AVPlayerItem, _ duration: Int?) {
        view.updateAfterAnimation() { [weak self] context in
            self?.view.openPlayer(duration: !item.duration.seconds.isNaN ? item.duration.seconds : Double(duration ?? 0))
        }
    }

    func itemTimeChanged(_ item: AVPlayerItem, _ sec: Double) {
        view.updateAfterAnimation() { [weak self] context in
            self?.view.updatePlayerProgress(percentages: Float(sec / item.duration.seconds), currentTime: sec)
        }
    }
    
    func playerStop() {
        view.updateAfterAnimation() { [weak self] context in
            self?.view.setPlayImage()
        }
    }
    
    func playerPlay() {
        view.updateAfterAnimation() { [weak self] context in
            self?.view.setPauseImage()
        }
    }
    
    func trackInfoChanged(_ track: CurrentTrack, _ imageData: Data?) {
        view.updateAfterAnimation() { [weak self] context in
            guard let `self` = self else { return }
            if let imageData = imageData {
                self.view.setTrackImage(imageData)
            } else {
                self.view.clearPlayer()
                self.view.setTrackInfo(title: track.title, performer: track.performer)
            }
        }
    }

}
