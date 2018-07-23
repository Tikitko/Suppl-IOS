import Foundation
import UIKit
import AVFoundation

class SmallPlayerPresenter: SmallPlayerPresenterProtocolInteractor, SmallPlayerPresenterProtocolView {
    
    var router: SmallPlayerRouterProtocol!
    var interactor: SmallPlayerInteractorProtocol!
    weak var view: SmallPlayerViewControllerProtocol!
    
    let rewindCount: Double = 15
    
    var playlist: [AudioData] = [] {
        willSet { view.setZeroTableOffset() }
        didSet { view.reloadTableData() }
    }
    
    var moduleNameId: String {
        get { return router.moduleNameId }
    }
    
    func setListener() {
        interactor.setListener(self)
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
        interactor.setPlayerCurrentTime(rewindCount, withCurrentTime: true)
    }
    
    func rewindM() {
        interactor.setPlayerCurrentTime(rewindCount * -1, withCurrentTime: true)
    }
    
    func mixButtonClick() {
        interactor.callMix()
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
        interactor.requestPlaylist()
        if view.nowShowType == .opened { return }
        view.setPlayerShowAnimated(type: .partOpened)
    }
    
    func playlistRemoved() {
        playlist = []
        if view.nowShowType == .opened { return }
        view.setPlayerShowAnimated(type: .closed)
    }
    
    func itemReadyToPlay(_ item: AVPlayerItem, _ duration: Int?) {
        view.updateAfterAnimation() { [weak self] context in
            let resultDuration = !item.duration.seconds.isNaN ? item.duration.seconds : Double(duration ?? 0)
            self?.view.openPlayer(duration: resultDuration)
        }
    }

    func itemTimeChanged(_ item: AVPlayerItem, _ sec: Double) {
        view.updateAfterAnimation() { [weak self] context in
            let resultPercentages = Float(sec / item.duration.seconds)
            self?.view.updatePlayerProgress(percentages: resultPercentages, currentTime: sec)
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
            if let imageData = imageData {
                self?.view.setTrackImage(imageData)
            } else {
                self?.view.clearPlayer()
                self?.view.setTrackInfo(title: track.title, performer: track.performer)
            }
        }
    }

}

extension SmallPlayerPresenter: TrackTableCommunicateProtocol {
    
    func requestConfigure() -> TableConfigure {
        return TableConfigure(
            light: true,
            smallCells: true,
            downloadButtons: false,
            followTrack: (true, false)
        )
    }
    
    func needTracksForReload() -> [AudioData] {
        return playlist
    }
    
}
