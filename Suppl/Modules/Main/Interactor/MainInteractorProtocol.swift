import Foundation

protocol MainInteractorProtocol: class {
    func loadBaseTracks()
    func clearData(withReload: Bool)
    func setSearchListener()
    func setTableListener()
}
