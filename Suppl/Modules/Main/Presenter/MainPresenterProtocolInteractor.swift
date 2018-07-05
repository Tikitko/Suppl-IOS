import Foundation

protocol MainPresenterProtocolInteractor: class {
    var moduleNameId: String { get }
    func searchQuery(_ query: String)
    func searchResult(query byQuery: String, data: AudioSearchData)
}
