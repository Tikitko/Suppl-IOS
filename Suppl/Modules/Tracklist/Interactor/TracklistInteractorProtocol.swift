import Foundation

protocol TracklistInteractorProtocol: class {
    func setSearchListener()
    func setFilterListener()
    func setTableListener()
    func load()
    func updateButtonClick()
}
