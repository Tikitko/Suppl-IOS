import Foundation

protocol TrackInfoInteractorProtocol: class, BaseInteractorProtocol {
    func setListener(_ delegate: CommunicateManagerProtocol)
    func setPlayerListener(_ delegate: PlayerListenerDelegate)
    func requestAdditionalInfo()
}
