import Foundation
import UIKit
import AVFoundation

class SmallPlayerPresenter: SmallPlayerPresenterProtocolInteractor, SmallPlayerPresenterProtocolView {
    
    var router: SmallPlayerRouterProtocol!
    var interactor: SmallPlayerInteractorProtocol!
    weak var view: SmallPlayerViewControllerProtocol!
    
    func setListener() {
        interactor.setListener(self)
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
        view.showPlayer()
    }
    
    func playlistRemoved() {
        view.closePlayer()
    }
    
    func itemReadyToPlay(_ item: AVPlayerItem) {
        view.openPlayer()
    }

    func itamTimeChanged(_ item: AVPlayerItem, _ sec: Double) {
        view.updatePlayerProgress(percentages: Float(sec / item.duration.seconds))
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
