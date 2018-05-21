import Foundation

class TrackTableCellInteractor: BaseInteractor, TrackTableCellInteractorProtocol {
    
    weak var presenter: TrackTableCellPresenterProtocol!
    
    func setListener(_ delegate: CommunicateManagerProtocol) {
        ModulesCommunicateManager.s.setListener(name: presenter.getModuleNameId(), delegate: delegate)
    }
    
    func setPlayerListener(_ delegate: PlayerListenerDelegate) {
        PlayerManager.s.setListener(name: presenter.getModuleNameId(), delegate: delegate)
    }
    
    func getRoundImageSetting() -> Bool {
        return SettingsManager.s.roundIcons!
    }
    
    func getCurrentTrackId() -> String? {
        return PlayerManager.s.currentTrack?.id
    }
    
}
