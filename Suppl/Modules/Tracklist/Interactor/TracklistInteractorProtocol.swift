import Foundation

protocol TracklistInteractorProtocol: class, BaseInteractorProtocol {
    func setListener(_ delegate: CommunicateManagerProtocol)
    func setTracklistListener(_ delegate: TracklistListenerDelegate)
    func requestOfflineStatus()
    func reloadWhenChangingSettings()
    func saveTracks(_ tracks: [AudioData])
    func tracklistUpdate()
    func updateTracks()
}
