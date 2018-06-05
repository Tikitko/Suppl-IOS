import Foundation

protocol MainPresenterProtocol: class {}

protocol MainPresenterProtocolInteractor: MainPresenterProtocol {
    var moduleNameId: String { get }
    func searchQuery(_ query: String)
    func searchResult(query byQuery: String, data: AudioSearchData)
}

protocol MainPresenterProtocolView: MainPresenterProtocol {
    func loadRandomTracks()
    func setListener()
}
