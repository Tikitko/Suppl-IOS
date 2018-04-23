import Foundation

protocol MainInteractorProtocol: class {
    func loadBaseTracks()
    func searchBarSearchButtonClicked(searchText: String)
    func clearData(withReload: Bool)
}
