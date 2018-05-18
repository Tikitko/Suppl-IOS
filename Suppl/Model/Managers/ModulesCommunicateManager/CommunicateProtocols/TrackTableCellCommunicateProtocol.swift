import Foundation

protocol TrackTableCellCommunicateProtocol: CommunicateManagerProtocol {
    func setNewData(id: String, title: String, performer: String, duration: Int)
    func setNewImage(imageData: NSData)
}
