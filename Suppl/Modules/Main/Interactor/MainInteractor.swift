import Foundation

class MainInteractor: MainInteractorProtocol {
    
    weak var presenter: MainPresenterProtocol!
    
    var reloadData: ((_ tracks: [AudioData], _ foundTracks: [AudioData]?) -> Void)!
    
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
        if let searchData = searchData {
            for track in searchData.list {
                guard let link = track.images.last else { continue }
                ImagesManager.removeFromCache(link: link)
            }
        }
        searchData = nil
        thisQuery = ""
        if withReload {
            updateTable()
        }
    }
    
    private func searchTracks(_ query: String, offset: Int = 0) {
        guard let (ikey, akey) = AuthManager.getAuthKeys() else { return }
        inSearchWork = true
        APIManager.audioSearch(ikey: ikey, akey: akey, query: query, offset: offset) { [weak self] error, data in
            defer { self?.inSearchWork = false }
            guard let `self` = self, let data = data else { return }
            self.addFoundTracks(data)
            self.thisQuery = query
            self.updateTable()
            
        }
    }
    
    private func addFoundTracks(_ data: AudioSearchData) {
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
        presenter.setInfo(searchData?.list.count == 0 ? "Ничего не найдено" : nil)
    }
    
    private func updateTable() {
        reloadData(searchData?.list ?? [], nil)
    }
    
    func searchBarSearchButtonClicked(searchText: String) {
        clearData()
        searchTracks(searchText)
        presenter.setOffsetZero()
    }
    
}
