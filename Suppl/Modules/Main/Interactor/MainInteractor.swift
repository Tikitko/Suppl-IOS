import Foundation

class MainInteractor: MainInteractorProtocol {
    
    weak var presenter: MainPresenterProtocol!
    
    var searchData: AudioSearchData?
    var thisQuery = ""
    
    var inSearchWork = false
    
    func loadBaseTracks() {
        let baseQueries = AppStaticData.baseSearchQueriesList
        let query = baseQueries[Int(arc4random_uniform(UInt32(baseQueries.count)))]
        presenter.setSearchQuery(query)
        searchTracks(query)
    }
    
    func loadMoreCallback(_ indexPath: IndexPath) -> Void {
        guard let data = self.searchData else { return }
        if self.inSearchWork { return }
        if data.list.count - 10 == indexPath.row, data.hasMore {
            self.inSearchWork = true
            self.searchTracks(self.thisQuery, offset: data.nextOffset)
        }
    }
    
    func clearData(withReload: Bool = true) {
        searchData = nil
        thisQuery = ""
        if withReload {
            presenter.reloadData()
        }
    }
    
    func setListener() {
        ModulesCommunicateManager.s.setListener(name: presenter.getModuleNameId(), delegate: self)
    }
    
    func searchTracks(_ query: String, offset: Int = 0) {
        guard let keys = AuthManager.s.getAuthKeys() else { return }
        inSearchWork = true
        presenter.setInfo(LocalesManager.s.get(.load))
        APIManager.s.audioSearch(keys: keys, query: query, offset: offset) { [weak self] error, data in
            defer {
                self?.inSearchWork = false
                self?.presenter.setInfo(nil)
            }
            guard let `self` = self, let data = data else { return }
            self.addFoundTracks(data)
            self.thisQuery = query
            self.presenter.reloadData()
        }
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
        presenter.setInfo(searchData?.list.count == 0 ? LocalesManager.s.get(.notFound) : nil)
    }
    
}

extension MainInteractor: SearchCommunicateProtocol {
    
    func searchButtonClicked(query: String) {
        clearData()
        searchTracks(query)
        presenter.setOffsetZero()
    }
    
}

extension MainInteractor: TrackTableCommunicateProtocol {
    
    func needTracksForReload() -> TracklistPair {
        return TracklistPair(tracks: searchData?.list ?? [], foundTracks: nil)
    }
    
    func cellShowAt(_ indexPath: IndexPath) {
        loadMoreCallback(indexPath)
    }
    
}

