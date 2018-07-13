import Foundation
import UIKit

class TrackTablePresenter: TrackTablePresenterProtocolInteractor, TrackTablePresenterProtocolView {
    
    var router: TrackTableRouterProtocol!
    var interactor: TrackTableInteractorProtocol!
    weak var view: TrackTableViewControllerProtocol!

    var tracks: [AudioData] = []
    var frashTracklist: [String]?
    
    var canEdit = false
    
    var moduleNameId: String {
        get { return router.moduleNameId }
    }
    
    func updateTracks() {
        tracks = interactor.communicateDelegate?.needTracksForReload() ?? tracks
    }
    
    func setCellSetting(_ value: Bool) {
        view.smallCell = value
    }
    
    func reloadData() {
        view.reloadData()
    }
    
    func requestCellSetting() {
        interactor.requestCellSetting()
    }
    
    func reloadWhenChangingSettings() {
        interactor.reloadWhenChangingSettings()
    }
    
    func resetCell(name: String) {
        interactor.getCellDelegate(name: name)?.needReset()
    }

    func setTracklist(_ tracklist: [String]?) {
        frashTracklist = tracklist
    }
    
    func load() {
        interactor.listenSettings()
        interactor.requestOfflineStatus()
        interactor.loadTracklist()
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
    
    func moveTrack(fromPath: IndexPath, toPath: IndexPath) {
        let trackInfo = tracks[fromPath.row]
        tracks.swapAt(fromPath.row, toPath.row)
        interactor.moveTrack(from: fromPath.row, to: toPath.row, track: trackInfo)
    }
    
    func canMoveTrack(fromPath: IndexPath) -> Bool {
        return tracks.count > fromPath.row
    }
    
    func rowEditStatus(indexPath: IndexPath) -> Bool {
        return canEdit
    }
    
    func rowEditType(indexPath: IndexPath) -> UITableViewCellEditingStyle {
        guard tracks.count > indexPath.row, let tracklist = frashTracklist else { return .none }
        return tracklist.index(of: tracks[indexPath.row].id) != nil ? .delete : .insert
    }
    
    func openPlayer(trackIndex: Int) {
        var tracksIDs: [String] = []
        for val in tracks {
            tracksIDs.append(val.id)
        }
        interactor.openPlayer(tracksIDs: tracksIDs, trackIndex: trackIndex, cachedTracksInfo: tracks)
    }
    
    func willDisplayCellForRowAt(_ indexPath: IndexPath) {
        interactor.communicateDelegate?.cellShowAt(indexPath)
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return tracks.count
    }
    
    func sendEditInfoToToast(expressionForTitle: LocalesManager.Expression, track: AudioData) {
        router.showToastOnTop(title: interactor.getLocaleString(expressionForTitle), body: "\(track.performer) - \(track.title)", duration: 2.0)
    }
    
    func sayThatZonePassed(toTop: Bool) {
        interactor.communicateDelegate?.zoneRangePassed(toTop: toTop)
    }
    
}

extension TrackTablePresenter: TracklistListenerDelegate {
    
    func tracklistUpdated(_ tracklist: [String]?) {
        setTracklist(tracklist)
    }
    
}
