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
    
    func setPlayerListener(_ delegate: PlayerListenerDelegate) {
        PlayerManager.shared.setListener(name: presenter.moduleNameId, delegate: delegate)
    }
    
    func setTracklistListener(_ delegate: TracklistListenerDelegate) {
        TracklistManager.shared.setListener(name: presenter.moduleNameId, delegate: delegate)
    }
    
    func listenSettings() {
        let NC = NotificationCenter.default
        NC.addObserver(self, selector: #selector(settingsChangedSet), name: .roundIconsSettingChanged, object: nil)
        NC.addObserver(self, selector: #selector(settingsChangedSet), name: .loadImagesSettingChanged, object: nil)
        NC.addObserver(self, selector: #selector(settingsChangedSet), name: .smallCellSettingChanged, object: nil)
        NC.addObserver(self, selector: #selector(settingsChangedSet), name: .imagesCacheRemoved, object: nil)
        NC.addObserver(self, selector: #selector(settingsChangedSet), name: .tracksCacheRemoved, object: nil)
        NC.addObserver(self, selector: #selector(settingsChangedSet), name: .themeSettingChanged, object: nil)
        NC.addObserver(self, selector: #selector(needReloadData), name: .themeSettingChanged, object: nil)
    }
    
    @objc func settingsChangedSet() {
        settingsChanged = true
    }
    
    @objc func needReloadData() {
        presenter.reloadData()
    }
    
    func requestOfflineStatus() {
        presenter.canEdit = !OfflineModeManager.shared.offlineMode
    }
    
    func loadTracklist() {
        presenter.frashTracklist = TracklistManager.shared.tracklist
    }
    
    func requestCellSetting() {
        presenter.setCellSetting(SettingsManager.shared.smallCell.value)
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
    
    func removeFromPlaylist(at: Int) {
        if PlayerManager.shared.playlist?.IDs.count == 1 {
            PlayerManager.shared.clearPlayer()
        } else {
            PlayerManager.shared.remove(at: at)
        }
    }
    
    func insertInPlaylist(track: AudioData) {
        if PlayerManager.shared.playlist == nil {
            PlayerManager.shared.setPlaylist(tracksIDs: [track.id], current: 0, cachedTracksInfo: [track])
        } else {
            PlayerManager.shared.insert(track.id, cachedTrackInfo: track)
        }
    }
    
    func openPlayer(tracksIDs: [String], trackIndex: Int, cachedTracksInfo: [AudioData]? = nil) {
        PlayerManager.shared.setPlaylist(tracksIDs: tracksIDs, current: trackIndex, cachedTracksInfo: cachedTracksInfo)
    }
    
    func loadImageData(link: String, callback: @escaping (_ data: Data) -> Void) {
        guard SettingsManager.shared.loadImages.value, !link.isEmpty else { return }
        RemoteDataManager.shared.getCachedImageAsData(link: link, callbackImageData: callback)
    }
  
}
