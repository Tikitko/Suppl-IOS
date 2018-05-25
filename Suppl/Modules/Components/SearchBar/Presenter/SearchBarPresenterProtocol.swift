import Foundation

protocol SearchBarPresenterProtocol: class {}

protocol SearchBarPresenterProtocolInteractor: SearchBarPresenterProtocol {}

protocol SearchBarPresenterProtocolView: SearchBarPresenterProtocol {
    func searchButtonClicked(query: String?) -> Void
}
