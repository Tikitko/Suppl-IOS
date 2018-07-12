import Foundation

class TrackInfoInteractor: BaseInteractor, TrackInfoInteractorProtocol {
    
    weak var presenter: TrackInfoPresenterProtocolInteractor!
    
    func setListener(_ delegate: CommunicateManagerProtocol) {
        ModulesCommunicateManager.shared.setListener(name: presenter.moduleNameId, delegate: delegate)
    }
    
    func setPlayerListener(_ delegate: PlayerListenerDelegate) {
        PlayerManager.shared.setListener(name: presenter.moduleNameId, delegate: delegate)
    }
    
    func requestAdditionalInfo(thisTrackId id: String, delegate: PlayerItemDelegate) {
        addTrackDelegate(thisTrackId: id, delegate: delegate)
        presenter.additionalInfo(currentPlayingId: PlayerManager.shared.currentTrack?.id, roundImage: SettingsManager.shared.roundIcons, downloadedStatus: PlayerItemsManager.shared.getItemStatus(id), lastLoadPercentages: PlayerItemsManager.shared.getItemLastLoadPercentages(id))
    }
    
    func addTrackDelegate(thisTrackId id: String, delegate: PlayerItemDelegate) {
        PlayerItemsManager.shared.setListener(itemName: id, listenerName: presenter.moduleNameId, delegate: delegate)
    }
    
    func clearTrackDelegate(thisTrackId id: String) {
        PlayerItemsManager.shared.removeListener(itemName: id, listenerName: presenter.moduleNameId)
    }
    
    func playerItemDoAction(trackId: String, statusWorking: PlayerItemsManager.ItemStatusWorking?) {
        switch (statusWorking, PlayerItemsManager.shared.getItemStatus(trackId)) {
        case let (sw, s) where sw == .addedToQueue || sw == .downloading || (s == .downloading || s == .inQueue && sw == nil):
            let _ = PlayerItemsManager.shared.removeActiveItem(trackId)
        case let (sw, s) where sw == .savedReceived || (s == .exist && sw == nil):
            let _ = PlayerItemsManager.shared.removeSavedItem(trackId)
        case let (sw, s) where sw == .errorReceived || sw == .cancel || sw == .removed || (s == .notExist && sw == nil):
            presenter.controlEnabled(false)
            PlayerItemsManager.shared.addItem(trackId) { [weak self] status in
                self?.presenter.controlEnabled(true)
            }
        default: break
        }
    }
    
    func requestOfflineMode() {
        presenter.isOffline = OfflineModeManager.shared.offlineMode
    }
    
}
