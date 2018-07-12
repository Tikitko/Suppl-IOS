import Foundation

protocol MainInteractorProtocol: class, BaseInteractorProtocol {
    func setListener(_ delegate: CommunicateManagerProtocol)
    func loadRandomTracks()
    func searchTracks(_ query: String, offset: Int)
}
