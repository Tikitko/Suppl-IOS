import Foundation

protocol MainPresenterProtocolView: class {
    func loadRandomTracks()
    func getTitle() -> String
    func setListener()
}
