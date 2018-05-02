import Foundation

protocol MainPresenterProtocol: class {
    func getModuleNameId() -> String
    func setSearchQuery(_ query: String)
    func setInfo(_ text: String?)
    func setOffsetZero()
    func load()
    func setListener()
    func reloadData()
}
