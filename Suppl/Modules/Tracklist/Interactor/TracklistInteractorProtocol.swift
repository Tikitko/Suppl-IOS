import Foundation

protocol TracklistInteractorProtocol: class, BaseInteractorProtocol {
    func setListener(_ delegate: CommunicateManagerProtocol)
    func setTracklistListener(_ delegate: TracklistListenerDelegate)
    func requestOfflineStatus()
    func saveTracks(_ tracks: [AudioData])
    func tracklistUpdate()
    func updateTracks()
}
