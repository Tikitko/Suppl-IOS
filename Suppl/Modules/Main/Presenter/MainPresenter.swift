import Foundation
import UIKit

class MainPresenter: ViperPresenter<MainRouterProtocol, MainInteractorProtocol, MainViewControllerProtocol>, MainPresenterProtocolInteractor, MainPresenterProtocolView {
    
    var searchData: AudioSearchData?
    var thisQuery = String()
    
    let moduleNameId: String
    
    required init(moduleId: String, parentModuleId: String?, args: [String : Any]) {
        moduleNameId = moduleId
        super.init()
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
    
    func createTrackTableModule() -> UITableViewController {
        return router.createTrackTableModule()
    }
    
    func createSearchBarModule() -> SearchBarViewController {
        return router.createSearchBarModule()
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
        if data.list.count - 10 == indexPath.row, data.hasMore, /* Backend fix: Start */ (!AppDelegate.enableBackendFixes || data.totalCount != 0 && data.nextOffset != 0) /* Backend fix: End */ {
            interactor.searchTracks(thisQuery, offset: data.nextOffset)
        }
    }
    
}
