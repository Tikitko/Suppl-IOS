import Foundation

protocol MainPresenterProtocol: class {}

protocol MainPresenterProtocolInteractor: MainPresenterProtocol {
    func getModuleNameId() -> String
    func searchQuery(_ query: String)
    func searchResult(query byQuery: String, data: AudioSearchData)
}

protocol MainPresenterProtocolView: MainPresenterProtocol {
    func loadRandomTracks()
    func setListener()
}
