import Foundation

class TrackTablePresenter: TrackTablePresenterProtocol {
    var router: TrackTableRouterProtocol!
    var interactor: TrackTableInteractorProtocol!
    weak var view: TrackTableViewControllerProtocol!
    
    func updateTracks() {
        interactor.updateTracks()
    }
    
    func openPlayer(tracksIDs: [String], current: Int) {
        router.openPlayer(tracksIDs: tracksIDs, current: current)
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return interactor.numberOfRowsInSection(section)
    }
    
    func getTrackDataById(_ id: Int, infoCallback: @escaping (_ data: AudioData) -> Void, imageCallback: @escaping (_ data: NSData) -> Void) {
        interactor.getTrackDataById(id, infoCallback: infoCallback, imageCallback: imageCallback)
    }
    
    func canEditRowAt(_ indexPath: IndexPath) -> Bool {
        return interactor.canEditRowAt(indexPath)
    }
    
    func editActionsForRowAt(_ indexPath: IndexPath) -> [RowAction] {
        return interactor.editActionsForRowAt(indexPath)
    }
    
    func didSelectRowAt(_ indexPath: IndexPath) {
        interactor.didSelectRowAt(indexPath)
    }
    
    func willDisplayCellForRowAt(_ indexPath: IndexPath) {
        interactor.willDisplayCellForRowAt(indexPath)
    }
}
