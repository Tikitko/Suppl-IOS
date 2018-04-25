import Foundation

protocol TracklistPresenterProtocol: class {
    
    func updateButtonIsEnabled(_ value: Bool)
    func clearSearch()
    func searchBarSearchButtonClicked(searchText: String)
    func setInfo(_ text: String?)
    func load()
    func updateButtonClick()
    func filterButtonClick(_ sender: Any)
    func timeChange(_ value: inout Float)
    func titleChange(_ value: inout Bool)
    func performerChange(_ value: inout Bool)
}
