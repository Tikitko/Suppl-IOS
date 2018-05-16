import Foundation

class MainInteractor: BaseInteractor, MainInteractorProtocol {
    
    weak var presenter: MainPresenterProtocol!
    
    var inSearchWork = false
    
    func setListener(_ delegate: CommunicateManagerProtocol) {
        ModulesCommunicateManager.s.setListener(name: presenter.getModuleNameId(), delegate: delegate)
    }
    
    func loadRandomTracks() -> String {
        let baseQueries = AppStaticData.baseSearchQueriesList
        let query = baseQueries[Int(arc4random_uniform(UInt32(baseQueries.count)))]
        searchTracks(query)
        return query
    }
    
    func searchTracks(_ query: String, offset: Int = 0) {
        guard !inSearchWork, let keys = getKeys() else { return }
        inSearchWork = true
        APIManager.s.audioSearch(keys: keys, query: query, offset: offset) { [weak self] error, data in
            defer { self?.inSearchWork = false }
            guard let `self` = self, let data = data else { return }
            self.presenter.searchResult(query: query, data: data)
        }
    }
    
}
