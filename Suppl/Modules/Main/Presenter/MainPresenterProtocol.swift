import Foundation

protocol MainPresenterProtocol: class {
    func setSearchQuery(_ query: String)
    func searchButtonClicked(searchText: String)
    func setInfo(_ text: String?)
    func setOffsetZero()
    func load()
}
