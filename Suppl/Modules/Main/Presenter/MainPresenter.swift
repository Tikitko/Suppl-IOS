import Foundation

class MainPresenter: MainPresenterProtocol {
    
    var router: MainRouterProtocol!
    var interactor: MainInteractorProtocol!
    weak var view: MainViewControllerProtocol!
    
    var searchData: AudioSearchData?
    var thisQuery = ""
    
    func getModuleNameId() -> String {
        return router.moduleNameId
    }
    
    func settingsTitle() -> String {
        return interactor.getLocaleString(.musicTitle)
    }
    
    func setListener() {
        interactor.setListener(self)
    }
    
    func setInfo(_ text: String? = nil) {
        text != nil ? view.onLabel(text: text!) : view.offLabel()
    }
    
    func loadRandomTracks() {
        view.setSearchQuery(interactor.loadRandomTracks())
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
        setInfo(interactor.getLocaleString(.load))
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
    
    func cellShowAt(_ indexPath: IndexPath) {
        guard let data = self.searchData else { return }
        if data.list.count - 10 == indexPath.row, data.hasMore {
            interactor.searchTracks(thisQuery, offset: data.nextOffset)
        }
    }

    
}
