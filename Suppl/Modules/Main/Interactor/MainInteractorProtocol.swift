import Foundation

protocol MainInteractorProtocol: class {
    func setListener(_ delegate: CommunicateManagerProtocol)
    func loadRandomTracks() -> String
    func searchTracks(_ query: String, offset: Int)
    func getKeys() -> KeysPair?
    func getLocaleString(_ forKey: LocalesManager.Expression) -> String
}
