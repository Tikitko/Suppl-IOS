import Foundation

protocol TracklistViewControllerProtocol: class {
    func updateButtonIsEnabled(_ value: Bool)
    func clearSearch()
    func onLabel(text: String)
    func offLabel()
}
