import Foundation

protocol TrackInfoCommunicateProtocol: CommunicateManagerProtocol {
    func setNewData(id: String, title: String, performer: String, duration: Int)
    func setNewImage(imageData: NSData)
    func needReset()
}
