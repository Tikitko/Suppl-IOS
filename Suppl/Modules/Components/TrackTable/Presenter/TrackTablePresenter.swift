import Foundation
import UIKit

class TrackTablePresenter: ViperPresenter<TrackTableRouterProtocol, TrackTableInteractorProtocol, TrackTableViewControllerProtocol>, TrackTablePresenterProtocolView, TrackTablePresenterProtocolInteractor {
    
    private struct Constants {
        static let actionColorRedOneHash = "#FF0000"
        static let actionColorGreenOneHash = "#4FAB5B"
        static let actionColorRedTwoHash = "#900101"
        static let actionColorGreenTwoHash = "#819D13"
    }
    
    var tracks: [AudioData] = []
    
    var frashTracklist: [String]?
    var frashPlaylist: Playlist?
    
    var canEdit = false
    var configureLoaded = false
    
    var followCurrentTrack: (Bool, inVisibilityZone: Bool) = (false, false)
    
    let moduleNameId: String
    
    required init(moduleId: String, args: [String : Any]) {
        moduleNameId = moduleId
        super.init()
    }
    
    func updateTracks() {
        guard let tracks = interactor.communicateDelegate?.needTracksForReload() else { return }
        self.tracks = tracks
    }
    
    func setCellSetting(_ value: Bool) {
        view.setSmallCells(value, forAlways: false)
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
    
    func setCellSetup(name: String, light: Bool, downloadButton: Bool) {
        interactor.getCellDelegate(name: name)?.setSetup(
            light: light,
            downloadButton: downloadButton
        )
    }
    
    func load() {
        interactor.listenSettings()
        interactor.requestOfflineStatus()
        interactor.loadTracklist()
        interactor.setTracklistListener(self)
        interactor.setPlayerListener(self)
    }
    
    func loadConfigure() {
        guard !configureLoaded,
              let configureBox = interactor.communicateDelegate?.requestConfigure()
            else { return }
        view.allowDownloadButton = configureBox.downloadButtons
        view.useLightStyle = configureBox.light
        followCurrentTrack = configureBox.followTrack
        if configureBox.smallCells != nil {
            view.setSmallCells(configureBox.smallCells!, forAlways: true)
        }
        configureLoaded = true
    }
    
    func updateCellInfo(trackIndex: Int, name: String) {
        guard tracks.count > trackIndex else { return }
        let track = tracks[trackIndex]
        interactor.getCellDelegate(name: name)?.setNewData(
            id: track.id,
            title: track.title,
            performer: track.performer,
            duration: track.duration
        )
        guard let imageLink = tracks[trackIndex].images.last else { return }
        interactor.loadImageData(link: imageLink) { [weak self] imageData in
            self?.interactor.getCellDelegate(name: name)?.setNewImage(imageData: imageData)
        }
    }
    
    //
    //       @@@@          @@@@
    //     @@@@@@@@      @@@@@@@@
    //    @@@@@@@@@@    @@@@@@@@@@
    //   @@@@@@@@@@@@  @@@@@@@@@@@@
    //   @@@@@@@@@@@@@@@@@@@@@@@@@@
    //   @@@@@@@@@@@@@@@@@@@@@@@@@@
    //     @@@@@@@@@@@@@@@@@@@@@@
    //       @@@@@@@@@@@@@@@@@@
    //         @@@@@@@@@@@@@@
    //           @@@@@@@@@@
    //             @@@@@@
    //              @@@@
    //               @@
    //
    //  ANN
    
    func createRowActions(indexPath: IndexPath) -> [RowAction]? {
        guard tracks.count > indexPath.row,
              let tracklist = frashTracklist
            else { return nil }
        var actions: [RowAction] = []
        let thisTrack = tracks[indexPath.row]
        if canEdit {
            if let indexTrack = tracklist.firstIndex(of: thisTrack.id) {
                let action: (IndexPath) -> Void = { [weak self] _ in
                    self?.interactor.removeTrack(indexTrack: indexTrack, track: self!.tracks[indexPath.row])
                }
                actions.append(RowAction(
                    color: Constants.actionColorRedOneHash,
                    title: "del".localizeKey,
                    action: action
                ))
            } else {
                let action: (IndexPath) -> Void = { [weak self] _ in
                    self?.interactor.addTrack(trackId: thisTrack.id, track: self!.tracks[indexPath.row])
                }
                actions.append(RowAction(
                    color: Constants.actionColorGreenOneHash,
                    title: "add".localizeKey,
                    action: action
                ))
            }
        }
        
        let playlist = frashPlaylist
        if let indexTracklist = playlist?.IDs.firstIndex(where: { $0 == thisTrack.id }) {
            let action: (IndexPath) -> Void = { [weak self] _ in
                self?.interactor.removeFromPlaylist(at: indexTracklist)
            }
            actions.append(RowAction(
                color: Constants.actionColorRedTwoHash,
                title: "removeFromPlaylist".localizeKey,
                action: action
            ))
        } else {
            let action: (IndexPath) -> Void = { [weak self] _ in
                self?.interactor.insertInPlaylist(track: thisTrack)
            }
            actions.append(RowAction(
                color: Constants.actionColorGreenTwoHash,
                title: "insertInPlaylist".localizeKey,
                action: action
            ))
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
        return true
    }
    
    func rowEditType(indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard tracks.count > indexPath.row, let tracklist = frashTracklist else { return .none }
        return tracklist.firstIndex(of: tracks[indexPath.row].id) != nil ? .delete : .insert
    }
    
    func openPlayer(trackIndex: Int) {
        var tracksIDs: [String] = []
        for val in tracks {
            tracksIDs.append(val.id)
        }
        interactor.openPlayer(
            tracksIDs: tracksIDs,
            trackIndex: trackIndex,
            cachedTracksInfo: tracks
        )
    }
    
    func willDisplayCellForRowAt(_ indexPath: IndexPath) {
        interactor.communicateDelegate?.cellShowAt(indexPath)
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return tracks.count
    }
    
    func sendEditInfoToToast(localizationKeyForTitle: String, track: AudioData) {
        router.showToastOnTop(
            title: localizationKeyForTitle.localizeKey,
            body: "\(track.performer) - \(track.title)",
            duration: 2.0
        )
    }
    
    func sayThatZonePassed(toTop: Bool) {
        interactor.communicateDelegate?.zoneRangePassed(toTop: toTop)
    }
    
    func getCell(isSmall: Bool) -> (moduleNameId: String, controller: UIViewController) {
        return router.createCell(isSmall: isSmall)
    }
    
}

extension TrackTablePresenter: TracklistListenerDelegate {
    
    func tracklistUpdated(_ tracklist: [String]?) {
        frashTracklist = tracklist
    }
    
}

extension TrackTablePresenter: PlayerListenerDelegate {
    
    func playlistChanged(_ playlist: Playlist?) {
        frashPlaylist = playlist
    }
    
    func trackInfoChanged(_ track: CurrentTrack, _ imageData: Data?) {
        guard imageData == nil,
              followCurrentTrack.0,
              let index = tracks.firstIndex(where: { $0.id == track.id })
            else { return }
        view.followToIndex(index, inVisibilityZone: followCurrentTrack.inVisibilityZone)
    }
    
}
