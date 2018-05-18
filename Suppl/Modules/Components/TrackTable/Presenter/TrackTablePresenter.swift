import Foundation
import UIKit

class TrackTablePresenter: TrackTablePresenterProtocol {
    
    var router: TrackTableRouterProtocol!
    var interactor: TrackTableInteractorProtocol!
    weak var view: TrackTableViewControllerProtocol!

    var tracks: [AudioData] = []

    func updateTracks() {
        tracks = interactor.getDelegate()?.needTracksForReload() ?? tracks
    }
    
    func updateCellInfo(trackIndex: Int, name: String) {
        guard tracks.count > trackIndex else { return }
        let track = tracks[trackIndex]
        interactor.getCellDelegate(name: name)?.setNewData(id: track.id, title: track.title, performer: track.performer, duration: track.duration)
        guard let imageLink = tracks[trackIndex].images.last else { return }
        interactor.loadImageData(link: imageLink) { [weak self] imageData in
            self?.interactor.getCellDelegate(name: name)?.setNewImage(imageData: imageData)
        }
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
