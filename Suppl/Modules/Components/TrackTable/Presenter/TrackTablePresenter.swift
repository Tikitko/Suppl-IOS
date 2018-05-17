import Foundation

class TrackTablePresenter: TrackTablePresenterProtocol {
    
    var router: TrackTableRouterProtocol!
    var interactor: TrackTableInteractorProtocol!
    weak var view: TrackTableViewControllerProtocol!

    var tracks: [AudioData] = []

    func updateTracks() {
        tracks = interactor.getDelegate()?.needTracksForReload() ?? tracks
    }
    
    func getTrackDataByIndex(_ index: Int, infoCallback: @escaping (_ data: AudioData) -> Void, imageCallback: @escaping (_ data: NSData) -> Void) {
        guard tracks.count > index else { return }
        infoCallback(tracks[index])
        guard let imageLink = tracks[index].images.last else { return }
        interactor.loadImageData(link: imageLink, callback: imageCallback)
    }
    
    func createRowActions(indexPath: IndexPath, actions: inout [RowAction]) {
        guard tracks.count > indexPath.row, let tracklist = interactor.getTracklist() else { return }
        let thisTrack = tracks[indexPath.row].id
        if let indexTrack = tracklist.index(of: thisTrack) {
            actions.append(RowAction(color: "#FF0000", title: interactor.getLocaleString(.del)) { [weak self] index in
                self?.interactor.removeTrack(indexTrack: indexTrack)
            })
        } else {
            actions.append(RowAction(color: "#4FAB5B", title: interactor.getLocaleString(.add)) { [weak self] index in
                self?.interactor.addTrack(trackId: thisTrack)
            })
        }
    }
    
    func rowEditStatus(indexPath: IndexPath) -> Bool {
        return true
    }
    
    func openPlayer(trackIndex: Int) {
        var tracksIDs: [String] = []
        for val in tracks {
            tracksIDs.append(val.id)
        }
        interactor.openPlayer(tracksIDs: tracksIDs, trackIndex: trackIndex)
    }
    
    func willDisplayCellForRowAt(_ indexPath: IndexPath) {
        interactor.getDelegate()?.cellShowAt(indexPath)
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return tracks.count
    }
    
}
