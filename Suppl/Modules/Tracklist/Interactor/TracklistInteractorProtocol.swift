import Foundation

protocol TracklistInteractorProtocol: class {
    var titleCallback: (( _: inout Bool) -> Void)! { get }
    var performerCallback: (( _: inout Bool) -> Void)! { get }
    var timeCallback: (( _: inout Float) -> Void)! { get }
    var searchByTitle: Bool { get }
    var searchByPerformer: Bool { get }
    var searchTimeRate: Float { get }
    
    func load()
    func searchBarSearchButtonClicked(searchText: String)
    func updateButtonClick()
}
