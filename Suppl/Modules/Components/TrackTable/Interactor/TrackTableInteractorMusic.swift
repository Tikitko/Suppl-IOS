import Foundation

class TrackTableInteractorMusic: TrackTableInteractorProtocol {
    weak var presenter: TrackTablePresenterProtocol!
    
    var tracks: [AudioData] = []
    var foundTracks: [AudioData]?
    
    var updateCallback: (_ indexPath: IndexPath) -> Void
    
    init(updateCallback: @escaping (_ indexPath: IndexPath) -> Void) {
        self.updateCallback = updateCallback
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return tracks.count
    }
    
    func cellForRowAt(_ indexPath: IndexPath, _ cell: TrackTableCell) -> TrackTableCell {
        let track = tracks[indexPath.row]
        cell.configure(title: track.title, performer: track.performer, duration: track.duration)
        guard let imageLink = track.images.last, imageLink != "" else { return cell }
        ImagesManager.s.getImage(link: imageLink) { image in
            guard cell.baseImage else { return }
            cell.setImage(imageData: image)
        }
        return cell
    }
    
    func canEditRowAt(_ indexPath: IndexPath) -> Bool {
        return true
    }
    
    func editActionsForRowAt(_ indexPath: IndexPath) -> [RowAction] {
        var actions: [RowAction] = []
        guard let tracklist = TracklistManager.s.tracklist else { return [] }
        if let indexTrack = tracklist.index(of: tracks[indexPath.row].id) {
            actions.append(RowAction(color: "#FF0000", title: LocalesManager.s.get(.del)) { index in
                TracklistManager.s.remove(from: indexTrack) { status in }
            })
        } else {
            actions.append(RowAction(color: "#4FAB5B", title: LocalesManager.s.get(.add)) { [weak self] index in
                guard let `self` = self else { return }
                TracklistManager.s.add(trackId: self.tracks[indexPath.row].id) { status in }
            })
        }
    
        return actions
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        var tracksIDs: [String] = []
        for val in tracks {
            tracksIDs.append(val.id)
        }
        presenter.openPlayer(tracksIDs: tracksIDs, current: indexPath.row)
    }
    
    func willDisplayCellForRowAt(_ indexPath: IndexPath) {
        updateCallback(indexPath)
    }
    
}
