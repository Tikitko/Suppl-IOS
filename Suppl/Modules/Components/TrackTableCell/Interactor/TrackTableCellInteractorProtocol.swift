import Foundation

protocol TrackTableCellInteractorProtocol: class {
    func setListener(_ delegate: CommunicateManagerProtocol)
    func setPlayerListener(_ delegate: PlayerListenerDelegate)
    func getRoundImageSetting() -> Bool
    func getCurrentTrackId() -> String?
}
