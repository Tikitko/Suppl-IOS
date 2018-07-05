import Foundation

protocol SearchCommunicateProtocol: CommunicateManagerProtocol {
    func searchButtonClicked(query: String) -> Void
}
