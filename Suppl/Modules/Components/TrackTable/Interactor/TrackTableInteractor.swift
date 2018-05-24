import Foundation

class TrackTableInteractor: BaseInteractor, TrackTableInteractorProtocol {

    weak var presenter: TrackTablePresenterProtocol!
    
    let parentModuleNameId: String
    init(parentModuleNameId: String) {
        self.parentModuleNameId = parentModuleNameId
    }
    
    func getDelegate() -> TrackTableCommunicateProtocol? {
        return ModulesCommunicateManager.s.getListener(name: parentModuleNameId) as? TrackTableCommunicateProtocol
    }
    
    func getCellDelegate(name: String) -> TrackInfoCommunicateProtocol? {
        return ModulesCommunicateManager.s.getListener(name: name) as? TrackInfoCommunicateProtocol
    }
    
    func setTracklistListener(_ delegate: TracklistListenerDelegate) {
        TracklistManager.s.setListener(name: presenter.getModuleNameId(), delegate: delegate)
    }
    
    func laodTracklist() {
        presenter.setTracklist(TracklistManager.s.tracklist)
    }

    func addTrack(trackId: String, track: AudioData)  {
        TracklistManager.s.add(trackId: trackId) { [weak self] status in
            guard status else {
                self?.presenter.sendEditInfoToToast(expressionForTitle: .addError, track: track)
                return
            }
            self?.presenter.sendEditInfoToToast(expressionForTitle: .addOk, track: track)
            self?.getDelegate()?.addedTrack(withId: trackId)
        }
    }
    
    func removeTrack(indexTrack: Int, track: AudioData) {
        TracklistManager.s.remove(from: indexTrack) { [weak self] status in
            guard status else {
                self?.presenter.sendEditInfoToToast(expressionForTitle: .removeError, track: track)
                return
            }
            self?.presenter.sendEditInfoToToast(expressionForTitle: .removeOk, track: track)
            self?.getDelegate()?.removedTrack(fromIndex: indexTrack)
        }
    }
    
    func openPlayer(tracksIDs: [String], trackIndex: Int, cachedTracksInfo: [AudioData]? = nil) {
        PlayerManager.s.setPlaylist(tracksIDs: tracksIDs, current: trackIndex, cachedTracksInfo: cachedTracksInfo)
    }
    
    func loadImageData(link: String, callback: @escaping (_ data: NSData) -> Void) {
        guard SettingsManager.s.loadImages!, link != "" else { return }
        RemoteDataManager.s.getData(link: link, callbackData: callback)
    }
  
}
