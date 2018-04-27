import Foundation

protocol MainViewControllerProtocol: class {
    func reloadData()
    func onLabel(text: String)
    func offLabel()
    func setSearchQuery(_ query: String)
    func setOffsetZero()
}
