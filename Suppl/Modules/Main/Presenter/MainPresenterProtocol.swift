import Foundation

protocol MainPresenterProtocol: class {
    func getModuleNameId() -> String
    func searchQuery(_ query: String)
    func loadRandomTracks()
    func setListener()
    func searchResult(query byQuery: String, data: AudioSearchData)
}
