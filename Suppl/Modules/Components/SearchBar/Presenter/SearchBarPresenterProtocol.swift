import Foundation

protocol SearchBarPresenterProtocol: class {
    func searchButtonClicked(query: String?) -> Void
}
