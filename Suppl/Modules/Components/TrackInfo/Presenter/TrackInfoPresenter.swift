import Foundation
import UIKit

class TrackInfoPresenter: ViperPresenter<TrackInfoRouterProtocol, TrackInfoInteractorProtocol, TrackInfoViewControllerProtocol>, TrackInfoPresenterProtocolInteractor, TrackInfoPresenterProtocolView {
    
    var trackId: String?
    var downloadStatusWorking: PlayerItemsManager.ItemStatusWorking?
    var isOffline: Bool = true
    
    let moduleNameId: String
    
    required init(moduleId: String, args: [String : Any]) {
        moduleNameId = moduleId
        super.init()
    }
    
    func setListeners() {
        interactor.setListener(self)
        interactor.setPlayerListener(self)
    }
    
    func setSelectedIfCurrent(id: String? = nil, instantly: Bool = false) {
        view.setSelected(id != nil && id == trackId, instantly: instantly)
    }
    
    func requestOfflineMode() {
        interactor.requestOfflineMode()
    }
    
    func additionalInfo(currentPlayingId: String?, roundImage: Bool, downloadedStatus status: PlayerItemsManager.ItemStatus, lastLoadPercentages: Int?) {
        view.setRoundImage(roundImage)
        setSelectedIfCurrent(id: currentPlayingId, instantly: true)
        switch status {
        case .downloading, .inQueue:
            setLoadButtonType(.сancel)
            view.setLoadPercentages(lastLoadPercentages ?? 0)
            view.turnLoad(true)
        case .exist:
            setLoadButtonType(.remove)
            view.turnLoadImage(true)
        case .notExist:
            setLoadButtonType(.download)
        }
    }
    
    func clearTrack() {
        if let trackId = trackId {
            interactor.clearTrackDelegate(thisTrackId: trackId)
        }
        trackId = nil
        downloadStatusWorking = nil
    }
    
    func setLoadButtonType(_ type: TrackInfoViewController.LoadButtonType?) {
        if let type = type {
            view.turnLoadButton(true)
            view.setLoadButtonType(type)
        } else {
            view.turnLoadButton(false)
        }
    }
    
    func controlEnabled(_ value: Bool) {
        view.enableLoadButton(value)
    }
    
    func loadButtonClick() {
        guard let trackId = trackId else { return }
        interactor.playerItemDoAction(trackId: trackId, statusWorking: downloadStatusWorking)
    }
    
}

extension TrackInfoPresenter: PlayerListenerDelegate {

    func trackInfoChanged(_ track: CurrentTrack, _ imageData: Data?) {
        setSelectedIfCurrent(id: track.id)
    }
    
    func playlistRemoved() {
        setSelectedIfCurrent()
    }
    
}

extension TrackInfoPresenter: TrackInfoCommunicateProtocol {
    
    func setSetup(light: Bool, downloadButton: Bool) {
        view.allowDownloadButton = downloadButton
        view.lightStyle = light
    }

    func setNewData(id: String, title: String, performer: String, duration: Int) {
        trackId = id
        interactor.requestAdditionalInfo(thisTrackId: id, delegate: self)
        view.setInfo(title: title, performer: performer, durationString: TrackTime(sec: duration).formatted)
    }
    
    func setNewImage(imageData: Data) {
        guard let image = UIImage(data: imageData) else { return }
        view.setImage(image)
    }
    
    func needReset() {
        view.resetInfo()
    }
    
}

extension TrackInfoPresenter: PlayerItemDelegate {
    
    func itemStatusChanged(_ itemName: String, _ status: PlayerItemsManager.ItemStatusWorking) {
        downloadStatusWorking = status
        switch status {
        case .addedToQueue, .downloading:
            view.turnLoad(true)
            setLoadButtonType(.сancel)
        case .errorReceived, .cancel, .removed:
            view.turnLoad(false)
            view.turnLoadImage(false)
            setLoadButtonType(.download)
        case .savedReceived:
            view.turnLoad(false)
            view.turnLoadImage(true)
            setLoadButtonType(.remove)
        }
    }
    
    func itemDownloadingProgressChanged(_ itemName: String, _ percentDownloaded: Int) {
        view.setLoadPercentages(percentDownloaded)
    }
    
}
