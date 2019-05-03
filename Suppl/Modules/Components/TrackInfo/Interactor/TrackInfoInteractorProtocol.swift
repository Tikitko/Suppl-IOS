import Foundation

protocol TrackInfoInteractorProtocol: class {
    func setListener(_ delegate: CommunicateManagerProtocol)
    func setPlayerListener(_ delegate: PlayerListenerDelegate)
    func requestAdditionalInfo(thisTrackId id: String, delegate: PlayerItemDelegate)
    func clearTrackDelegate(thisTrackId id: String)
    func playerItemDoAction(trackId: String, statusWorking: PlayerItemsManager.ItemStatusWorking?)
    func requestOfflineMode()
}
