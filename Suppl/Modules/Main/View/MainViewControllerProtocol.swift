import Foundation

protocol MainViewControllerProtocol: class {
    func reloadData()
    func setLabel(_ text: String?)
    func setSearchQuery(_ query: String)
    func setOffsetZero()
}
