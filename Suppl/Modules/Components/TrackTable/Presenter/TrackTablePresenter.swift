import Foundation
import UIKit

class TrackTablePresenter: TrackTablePresenterProtocol {
    
    var router: TrackTableRouterProtocol!
    var interactor: TrackTableInteractorProtocol!
    weak var view: TrackTableViewControllerProtocol!

    var tracks: [AudioData] = []
    var frashTracklist: [String]?
    
    func getModuleNameId() -> String {
        return router.moduleNameId
    }
    
    func updateTracks() {
        tracks = interactor.getDelegate()?.needTracksForReload() ?? tracks
    }
    
    func resetCell(name: String) {
        interactor.getCellDelegate(name: name)?.needReset()
    }

    func setTracklist(_ tracklist: [String]?) {
        frashTracklist = tracklist
    }
    
    func load() {
        interactor.laodTracklist()
        interactor.setTracklistListener(self)
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
    
    func createRowActions(indexPath: IndexPath) -> [RowAction]? {
        guard tracks.count > indexPath.row, let tracklist = frashTracklist else { return nil }
        var actions: [RowAction] = []
        let thisTrack = tracks[indexPath.row].id
        if let indexTrack = tracklist.index(of: thisTrack) {
            actions.append(RowAction(color: "#FF0000", title: interactor.getLocaleString(.del)) { [weak self] index in
                self?.interactor.removeTrack(indexTrack: indexTrack, track: self!.tracks[indexPath.row])
            })
        } else {
            actions.append(RowAction(color: "#4FAB5B", title: interactor.getLocaleString(.add)) { [weak self] index in
                self?.interactor.addTrack(trackId: thisTrack, track: self!.tracks[indexPath.row])
            })
        }
        return actions
    }
    
    func rowEditStatus(indexPath: IndexPath) -> Bool {
        return true
    }
    
    func openPlayer(trackIndex: Int) {
        var tracksIDs: [String] = []
        for val in tracks {
            tracksIDs.append(val.id)
        }
        interactor.openPlayer(tracksIDs: tracksIDs, trackIndex: trackIndex, cachedTracksInfo: tracks)
    }
    
    func willDisplayCellForRowAt(_ indexPath: IndexPath) {
        interactor.getDelegate()?.cellShowAt(indexPath)
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return tracks.count
    }
    
    func sendEditInfoToToast(expressionForTitle: LocalesManager.Expression, track: AudioData) {
        ToastTemplate.baseTop(title: interactor.getLocaleString(expressionForTitle), body: "\(track.performer) - \(track.title)")
    }
    
}

extension TrackTablePresenter: TracklistListenerDelegate {
    
    func tracklistUpdated(_ tracklist: [String]?) {
        setTracklist(tracklist)
    }
    
}
