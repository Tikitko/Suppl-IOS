import Foundation

class TrackInfoInteractor: BaseInteractor, TrackInfoInteractorProtocol {
    
    weak var presenter: TrackInfoPresenterProtocolInteractor!
    
    func setListener(_ delegate: CommunicateManagerProtocol) {
        ModulesCommunicateManager.s.setListener(name: presenter.moduleNameId, delegate: delegate)
    }
    
    func setPlayerListener(_ delegate: PlayerListenerDelegate) {
        PlayerManager.s.setListener(name: presenter.moduleNameId, delegate: delegate)
    }
    
    func requestAdditionalInfo(thisTrackId id: String, delegate: PlayerItemDelegate) {
        addTrackDelegate(thisTrackId: id, delegate: delegate)
        presenter.additionalInfo(currentPlayingId: PlayerManager.s.currentTrack?.id, roundImage: SettingsManager.s.roundIcons!, downloadedStatus: PlayerItemsManager.s.getItemStatus(id), lastLoadPercentages: PlayerItemsManager.s.getItemLastLoadPercentages(id))
    }
    
    func addTrackDelegate(thisTrackId id: String, delegate: PlayerItemDelegate) {
        PlayerItemsManager.s.setListener(itemName: id, listenerName: presenter.moduleNameId, delegate: delegate)
    }
    
    func clearTrackDelegate(thisTrackId id: String) {
        PlayerItemsManager.s.removeListener(itemName: id, listenerName: presenter.moduleNameId)
    }
    
    func playerItemDoAction(trackId: String, statusWorking: PlayerItemsManager.ItemStatusWorking?) {
        switch (statusWorking, PlayerItemsManager.s.getItemStatus(trackId)) {
        case let (sw, s) where sw == .addedToQueue || sw == .downloading || (s == .downloading || s == .inQueue && sw == nil):
            let _ = PlayerItemsManager.s.removeActiveItem(trackId)
        case let (sw, s) where sw == .savedReceived || (s == .exist && sw == nil):
            let _ = PlayerItemsManager.s.removeSavedItem(trackId)
        case let (sw, s) where sw == .errorReceived || sw == .cancel || sw == .removed || (s == .notExist && sw == nil):
            presenter.controlEnabled(false)
            PlayerItemsManager.s.addItem(trackId) { [weak self] status in
                self?.presenter.controlEnabled(true)
            }
        default: break
        }
    }
    
    func requestOfflineMode() {
        presenter.isOffline = OfflineModeManager.s.offlineMode
    }
    
}
