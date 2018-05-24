import Foundation

protocol TracklistInteractorProtocol: class, BaseInteractorProtocol {
    func setListener(_ delegate: CommunicateManagerProtocol)
    func setTracklistListener(_ delegate: TracklistListenerDelegate)
    func tracklistUpdate()
    func updateTracks()
}
