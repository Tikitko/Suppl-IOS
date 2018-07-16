import Foundation

protocol MainPresenterProtocolView: class {
    func load()
    func getTitle() -> String
    func getLoadLabel() -> String
    func getSearchLabel() -> String
}
