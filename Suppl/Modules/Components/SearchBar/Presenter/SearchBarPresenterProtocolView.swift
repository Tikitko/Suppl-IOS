import Foundation

protocol SearchBarPresenterProtocolView: class {
    func searchButtonClicked(query: String) -> Void
}
