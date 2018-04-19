import Foundation

class TrackTablePresenter: TrackTablePresenterProtocol {
    var router: TrackTableRouterProtocol!
    var interactor: TrackTableInteractorProtocol!
    weak var view: TrackTableViewProtocol!
    
    func updateTracks(tracks: [AudioData], foundTracks: [AudioData]?) {
        interactor.tracks = tracks
        interactor.foundTracks = foundTracks
    }
    
    func openPlayer(tracksIDs: [String], current: Int) {
        router.openPlayer(tracksIDs: tracksIDs, current: current)
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return interactor.numberOfRowsInSection(section)
    }
    
    func cellForRowAt(_ indexPath: IndexPath, _ cell: TrackTableCell) -> TrackTableCell {
        return interactor.cellForRowAt(indexPath, cell)
    }
    
    func canEditRowAt(_ indexPath: IndexPath) -> Bool {
        return interactor.canEditRowAt(indexPath)
    }
    
    func editActionsForRowAt(_ indexPath: IndexPath) -> [TrackTableInteractorTracklist.RowAction] {
        return interactor.editActionsForRowAt(indexPath)
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        interactor.didSelectRowAt(indexPath)
    }
    
    func willDisplayCellForRowAt(_ indexPath: IndexPath) {
        interactor.willDisplayCellForRowAt(indexPath)
    }
}
