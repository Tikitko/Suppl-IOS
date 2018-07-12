import Foundation

class TrackTableInteractor: BaseInteractor, TrackTableInteractorProtocol {

    weak var presenter: TrackTablePresenterProtocolInteractor!
    
    var settingsChanged: Bool = false
    
    let parentModuleNameId: String
    init(parentModuleNameId: String) {
        self.parentModuleNameId = parentModuleNameId
    }

    var communicateDelegate: TrackTableCommunicateProtocol? {
        get { return ModulesCommunicateManager.shared.getListener(name: parentModuleNameId) as? TrackTableCommunicateProtocol }
    }

    func getCellDelegate(name: String) -> TrackInfoCommunicateProtocol? {
        return ModulesCommunicateManager.shared.getListener(name: name) as? TrackInfoCommunicateProtocol
    }
    
    func setTracklistListener(_ delegate: TracklistListenerDelegate) {
        TracklistManager.shared.setListener(name: presenter.moduleNameId, delegate: delegate)
    }
    
    func listenSettings() {
        NotificationCenter.default.addObserver(self, selector: #selector(settingsChangedSet), name: .roundIconsSettingChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(settingsChangedSet), name: .loadImagesSettingChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(settingsChangedSet), name: .smallCellSettingChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(settingsChangedSet), name: .imagesCacheRemoved, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(settingsChangedSet), name: .tracksCacheRemoved, object: nil)
    }
    
    @objc func settingsChangedSet() {
        settingsChanged = true
    }
    
    func requestOfflineStatus() {
        presenter.canEdit = !OfflineModeManager.shared.offlineMode
    }
    
    func loadTracklist() {
        presenter.setTracklist(TracklistManager.shared.tracklist)
    }
    
    func requestCellSetting() {
        presenter.setCellSetting(SettingsManager.shared.smallCell)
    }
    
    func reloadWhenChangingSettings() {
        if settingsChanged {
            settingsChanged = false
            presenter.reloadData()
        }
    }

    func addTrack(trackId: String, track: AudioData)  {
        TracklistManager.shared.add(trackId: trackId) { [weak self] status in
            guard status else {
                self?.presenter.sendEditInfoToToast(expressionForTitle: .addError, track: track)
                return
            }
            self?.presenter.sendEditInfoToToast(expressionForTitle: .addOk, track: track)
            self?.communicateDelegate?.addedTrack(withId: trackId)
        }
    }
    
    func removeTrack(indexTrack: Int, track: AudioData) {
        TracklistManager.shared.remove(from: indexTrack) { [weak self] status in
            guard status else {
                self?.presenter.sendEditInfoToToast(expressionForTitle: .removeError, track: track)
                return
            }
            self?.presenter.sendEditInfoToToast(expressionForTitle: .removeOk, track: track)
            self?.communicateDelegate?.removedTrack(fromIndex: indexTrack)
        }
    }
    
    func moveTrack(from: Int, to: Int, track: AudioData) {
        TracklistManager.shared.move(from: from, to: to) { [weak self] status in
            guard status else {
                self?.presenter.sendEditInfoToToast(expressionForTitle: .moveError, track: track)
                return
            }
            self?.presenter.sendEditInfoToToast(expressionForTitle: .moveOk, track: track)
            self?.communicateDelegate?.moveTrack(from: from, to: to)
        }
    }
    
    func openPlayer(tracksIDs: [String], trackIndex: Int, cachedTracksInfo: [AudioData]? = nil) {
        PlayerManager.shared.setPlaylist(tracksIDs: tracksIDs, current: trackIndex, cachedTracksInfo: cachedTracksInfo)
    }
    
    func loadImageData(link: String, callback: @escaping (_ data: Data) -> Void) {
        guard SettingsManager.shared.loadImages, !link.isEmpty else { return }
        RemoteDataManager.shared.getCachedImageAsData(link: link, callbackImageData: callback)
    }
  
}
