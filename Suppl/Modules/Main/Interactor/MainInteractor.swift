import Foundation

class MainInteractor: MainInteractorProtocol {
    
    weak var presenter: MainPresenterProtocolInteractor!
    
    var inSearchWork = false
    
    func setListener(_ delegate: CommunicateManagerProtocol) {
        ModulesCommunicateManager.shared.setListener(name: presenter.moduleNameId, delegate: delegate)
    }
    
    func loadRandomTracks() {
        let baseQueries = AppDelegate.baseSearchQueriesList
        let query = baseQueries[Int(arc4random_uniform(UInt32(baseQueries.count)))]
        searchTracks(query)
        presenter.searchQuery(query)
    }
    
    func searchTracks(_ query: String, offset: Int = 0) {
        guard !inSearchWork, let keys = AuthManager.shared.getAuthKeys() else { return }
        inSearchWork = true
        APIManager.shared.audio.search(keys: keys, query: query, offset: offset) { [weak self] error, data in
            defer { self?.inSearchWork = false }
            guard let self = self, let data = data else { return }
            self.presenter.searchResult(query: query, data: data)
        }
    }
    
    func listenSettings() {
        NotificationCenter.default.addObserver(self, selector: #selector(requestHideLogoSetting), name: .hideLogoSettingChanged, object: nil)
    }
    
    @objc func requestHideLogoSetting() {
        presenter.canHideLogo = SettingsManager.shared.hideLogo.value
    }
    
}
