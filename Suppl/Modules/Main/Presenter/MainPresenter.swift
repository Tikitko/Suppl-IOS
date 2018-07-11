import Foundation

class MainPresenter: MainPresenterProtocolInteractor, MainPresenterProtocolView {
    
    var router: MainRouterProtocol!
    var interactor: MainInteractorProtocol!
    weak var view: MainViewControllerProtocol!
    
    var searchData: AudioSearchData?
    var thisQuery = ""
    
    var moduleNameId: String {
        get { return router.moduleNameId }
    }
    
    func getTitle() -> String {
        return interactor.getLocaleString(.musicTitle)
    }
    
    func getLoadLabel() -> String {
        return interactor.getLocaleString(.load)
    }
    
    func getSearchLabel() -> String {
        return interactor.getLocaleString(.searchMain)
    }
    
    func setListener() {
        interactor.setListener(self)
    }
    
    func setInfo(_ text: String? = nil) {
        view.setLabel(text)
    }
    
    func searchQuery(_ query: String) {
        view.setSearchQuery(query)
    }
    
    func reloadData() {
        view.reloadData()
    }
    
    func reloadWhenChangingSettings() {
        interactor.reloadWhenChangingSettings()
    }
    
    func loadRandomTracks() {
        interactor.loadRandomTracks()
    }
    
    func clearData(withReload: Bool = true) {
        searchData = nil
        thisQuery = ""
        if withReload {
            view.reloadData()
        }
    }
    
    func searchResult(query byQuery: String, data: AudioSearchData) {
        addFoundTracks(data)
        thisQuery = byQuery
        view.reloadData()
    }
    
    func addFoundTracks(_ data: AudioSearchData) {
        if let _ = searchData {
            for track in data.list {
                searchData?.list.append(track)
            }
            searchData?.nextOffset = data.nextOffset
            searchData?.hasMore = data.hasMore
            searchData?.totalCount = data.totalCount
        } else {
            searchData = data
        }
        setInfo(searchData?.list.count == 0 ? interactor.getLocaleString(.notFound) : nil)
    }
    
}

extension MainPresenter: SearchCommunicateProtocol {
    
    func searchButtonClicked(query: String) {
        clearData()
        setInfo(getLoadLabel())
        interactor.searchTracks(query, offset: 0)
        view.setOffsetZero()
    }
    
}

extension MainPresenter: TrackTableCommunicateProtocol {
    
    func needTracksForReload() -> [AudioData] {
        return searchData?.list ?? []
    }
    
    func removedTrack(fromIndex: Int) {}
    
    func addedTrack(withId: String) {}
    
    func moveTrack(from: Int, to: Int) {}
    
    func cellShowAt(_ indexPath: IndexPath) {
        guard let data = self.searchData else { return }
        if data.list.count - 10 == indexPath.row, data.hasMore {
            interactor.searchTracks(thisQuery, offset: data.nextOffset)
        }
    }

    
}
