import Foundation

class TrackInfoInteractor: BaseInteractor, TrackInfoInteractorProtocol {
    
    weak var presenter: TrackInfoPresenterProtocol!
    
    func setListener(_ delegate: CommunicateManagerProtocol) {
        ModulesCommunicateManager.s.setListener(name: presenter.getModuleNameId(), delegate: delegate)
    }
    
    func setPlayerListener(_ delegate: PlayerListenerDelegate) {
        PlayerManager.s.setListener(name: presenter.getModuleNameId(), delegate: delegate)
    }
    
    func requestAdditionalInfo() {
        guard let currentPlayingId = PlayerManager.s.currentTrack?.id else { return }
        presenter.additionalInfo(currentPlayingId: currentPlayingId, roundImage: SettingsManager.s.roundIcons!)
    }
    
}
