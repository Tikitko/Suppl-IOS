import Foundation

protocol MainPresenterProtocol: class {
    func setSearchQuery(_ query: String)
    func setInfo(_ text: String?)
    func setOffsetZero()
    func load()
    func setSearchListener()
    func setTableListener()
    func reloadData()
}
