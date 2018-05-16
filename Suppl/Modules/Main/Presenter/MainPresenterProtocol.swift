import Foundation

protocol MainPresenterProtocol: class {
    func getModuleNameId() -> String
    func settingsTitle() -> String
    func loadRandomTracks()
    func setListener()
    func searchResult(query byQuery: String, data: AudioSearchData)
}
