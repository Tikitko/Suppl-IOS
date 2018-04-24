import Foundation

protocol MainInteractorProtocol: class {
    func loadBaseTracks()
    func searchButtonClicked(searchText: String)
    func clearData(withReload: Bool)
}
