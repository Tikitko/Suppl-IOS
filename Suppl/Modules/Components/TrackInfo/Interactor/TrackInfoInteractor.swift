import Foundation

class TrackInfoInteractor: BaseInteractor, TrackInfoInteractorProtocol {
    
    weak var presenter: TrackInfoPresenterProtocolInteractor!
    
    func setListener(_ delegate: CommunicateManagerProtocol) {
        ModulesCommunicateManager.s.setListener(name: presenter.getModuleNameId(), delegate: delegate)
    }
    
    func setPlayerListener(_ delegate: PlayerListenerDelegate) {
        PlayerManager.s.setListener(name: presenter.getModuleNameId(), delegate: delegate)
    }
    
    func requestAdditionalInfo() {
        presenter.additionalInfo(currentPlayingId: PlayerManager.s.currentTrack?.id, roundImage: SettingsManager.s.roundIcons!)
    }
    
}
