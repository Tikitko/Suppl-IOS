import Foundation

class TrackTableInteractorTracklist: TrackTableInteractorProtocol {
    weak var presenter: TrackTablePresenterProtocol!
    
    var tracks: [AudioData] = []
    var foundTracks: [AudioData]?
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        if let foundTracks = foundTracks {
            return foundTracks.count
        }
        return tracks.count
    }
    
    func cellForRowAt(_ indexPath: IndexPath, _ cell: TrackTableCell) -> TrackTableCell {
        let track = foundTracks != nil ? foundTracks![indexPath.row] : tracks[indexPath.row]
        cell.configure(title: track.title, performer: track.performer, duration: track.duration)
        guard let imageLink = track.images.last, imageLink != "" else { return cell }
        ImagesManager.getImage(link: imageLink) { image in
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
        actions.append(RowAction(color: "#FF0000", title: "Удалить") { [weak self] index in
            guard let `self` = self else { return }
            guard let foundTracks = self.foundTracks else {
                TracklistManager.remove(from: index.row) { status in }
                return
            }
            for (key, track) in self.tracks.enumerated() {
                guard track.id == foundTracks[index.row].id else { continue }
                TracklistManager.remove(from: key) { [weak self] status in
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

}
