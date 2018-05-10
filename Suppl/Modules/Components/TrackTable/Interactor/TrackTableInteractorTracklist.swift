import Foundation

class TrackTableInteractorTracklist: TrackTableInteractorProtocol {
    weak var presenter: TrackTablePresenterProtocol!
    
    var tracks: [AudioData] = []
    var foundTracks: [AudioData]?
    
    let parentModuleNameId: String
    init(parentModuleNameId: String) {
        self.parentModuleNameId = parentModuleNameId
    }
    
    func getDelegate() -> TrackTableCommunicateProtocol? {
        return ModulesCommunicateManager.s.getListener(name: parentModuleNameId) as? TrackTableCommunicateProtocol
    }
    
    func updateTracks() {
        guard let tracksPair = getDelegate()?.needTracksForReload() else { return }
        tracks = tracksPair.tracks
        foundTracks = tracksPair.foundTracks
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        if let foundTracks = foundTracks {
            return foundTracks.count
        }
        return tracks.count
    }
    
    func getTrackDataById(_ id: Int, infoCallback: @escaping (_ data: AudioData) -> Void, imageCallback: @escaping (_ data: NSData) -> Void) {
        let track = foundTracks != nil ? foundTracks![id] : tracks[id]
        infoCallback(track)
        guard SettingsManager.s.loadImages!, let imageLink = track.images.last, imageLink != "" else { return }
        RemoteDataManager.s.getData(link: imageLink) { imageData in
            imageCallback(imageData)
        }
    }
    
    func canEditRowAt(_ indexPath: IndexPath) -> Bool {
        return true
    }
    
    func editActionsForRowAt(_ indexPath: IndexPath) -> [RowAction] {
        var actions: [RowAction] = []
        actions.append(RowAction(color: "#FF0000", title: LocalesManager.s.get(.del)) { [weak self] index in
            guard let `self` = self else { return }
            guard let foundTracks = self.foundTracks else {
                TracklistManager.s.remove(from: index.row) { status in }
                return
            }
            for (key, track) in self.tracks.enumerated() {
                guard track.id == foundTracks[index.row].id else { continue }
                TracklistManager.s.remove(from: key) { [weak self] status in
                    guard let `self` = self else { return }
                    self.foundTracks?.remove(at: index.row)
                }
                break
            }
        })
        return actions
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        var tracksIDs: [String] = []
        for val in tracks {
            tracksIDs.append(val.id)
        }
        presenter.openPlayer(tracksIDs: tracksIDs, current: indexPath.row)
    }
    
    func willDisplayCellForRowAt(_ indexPath: IndexPath) {}

    func openPlayer(tracksIDs: [String], current: Int) {
        PlayerManager.s.setPlaylist(tracksIDs: tracksIDs, current: current)
    }
}
