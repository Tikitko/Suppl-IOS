import Foundation

protocol MainPresenterProtocolView: class {
    func loadRandomTracks()
    func getTitle() -> String
    func getLoadLabel() -> String
    func getSearchLabel() -> String
    func setListener()
}
