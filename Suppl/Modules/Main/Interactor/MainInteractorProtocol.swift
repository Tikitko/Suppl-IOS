import Foundation

protocol MainInteractorProtocol: class {
    func setListener(_ delegate: CommunicateManagerProtocol)
    func loadRandomTracks()
    func searchTracks(_ query: String, offset: Int)
    func listenSettings()
    func requestHideLogoSetting()
}
