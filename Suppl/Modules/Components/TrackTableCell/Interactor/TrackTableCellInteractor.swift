import Foundation

class TrackTableCellInteractor: BaseInteractor, TrackTableCellInteractorProtocol {
    
    weak var presenter: TrackTableCellPresenterProtocol!
    
    func setListener(_ delegate: CommunicateManagerProtocol) {
        ModulesCommunicateManager.s.setListener(name: presenter.getModuleNameId(), delegate: delegate)
    }
    
    func setPlayerListener(_ delegate: PlayerListenerDelegate) {
        PlayerManager.s.setListener(name: presenter.getModuleNameId(), delegate: delegate)
    }
    
    func getLoadImageSetting() -> Bool {
        return SettingsManager.s.loadImages!
    }
    
    func getCurrentTrackId() -> String? {
        return PlayerManager.s.currentTrack?.id
    }
    
}
