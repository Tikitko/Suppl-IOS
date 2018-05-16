import Foundation

protocol TracklistInteractorProtocol: class {
    func setListener(_ delegate: CommunicateManagerProtocol)
    func tracklistObserver(isOn: Bool)
    func tracklistUpdate()
    func updateTracks()
    func getKeys() -> KeysPair?
    func getLocaleString(_ forKey: LocalesManager.Expression) -> String
}
