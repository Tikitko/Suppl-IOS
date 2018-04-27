import Foundation

protocol SearchBarInteractorProtocol: class {
    func searchButtonClicked(query: String) -> Void
}
