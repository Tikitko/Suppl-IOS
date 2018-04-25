import Foundation

protocol TracklistInteractorProtocol: class {
    var searchByTitle: Bool { get }
    var searchByPerformer: Bool { get }
    var searchTimeRate: Float { get }
    
    func load()
    func searchBarSearchButtonClicked(searchText: String)
    func updateButtonClick()
    
    func timeChange(_ value: inout Float)
    func titleChange(_ value: inout Bool)
    func performerChange(_ value: inout Bool)
}
