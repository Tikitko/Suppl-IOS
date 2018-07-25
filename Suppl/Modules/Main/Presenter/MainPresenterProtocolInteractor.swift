import Foundation

protocol MainPresenterProtocolInteractor: class {
    var moduleNameId: String { get }
    var canHideLogo: Bool? { get set }
    func searchQuery(_ query: String)
    func searchResult(query byQuery: String, data: AudioSearchData)
}
