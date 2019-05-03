import Foundation

class MainPresenter: MainPresenterProtocolInteractor, MainPresenterProtocolView {
    
    var router: MainRouterProtocol!
    var interactor: MainInteractorProtocol!
    weak var view: MainViewControllerProtocol!
    
    var searchData: AudioSearchData?
    var thisQuery = String()
    
    var moduleNameId: String {
        get { return router.moduleNameId }
    }
    
    var canHideLogo: Bool? {
        didSet {
            if canHideLogo == nil { return }
            view.setHideHeader(false, animated: false)
        }
    }
    
    func getTitle() -> String {
        return "musicTitle".localizeKey
    }
    
    func getLoadLabel() -> String {
        return "load".localizeKey
    }
    
    func getSearchLabel() -> String {
        return "searchMain".localizeKey
    }
    
    func setInfo(_ text: String? = nil) {
        view.setLabel(text)
    }
    
    func searchQuery(_ query: String) {
        view.setSearchQuery(query)
    }
    
    func load() {
        interactor.setListener(self)
        interactor.listenSettings()
        interactor.requestHideLogoSetting()
        interactor.loadRandomTracks()
    }
    
    func clearData(withReload: Bool = true) {
        searchData = nil
        thisQuery = String()
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
        setInfo(searchData?.list.count == 0 ? "notFound".localizeKey : nil)
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
    
    func requestConfigure() -> TableConfigure {
        return TableConfigure(
            light: false,
            smallCells: nil,
            downloadButtons: false,
            followTrack: (false, false)
        )
    }
    
    func needTracksForReload() -> [AudioData] {
        return searchData?.list ?? []
    }
    
    func zoneRangePassed(toTop: Bool) {
        guard canHideLogo ?? false else { return }
        view.setHideHeader(!toTop, animated: true)
    }
    
    func cellShowAt(_ indexPath: IndexPath) {
        guard let data = searchData else { return }
        if data.list.count - 10 == indexPath.row, data.hasMore {
            interactor.searchTracks(thisQuery, offset: data.nextOffset)
        }
    }
    
}
