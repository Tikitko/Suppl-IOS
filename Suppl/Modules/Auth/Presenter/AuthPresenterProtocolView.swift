import Foundation

protocol AuthPresenterProtocolView: class {
    func getButtonLabel() -> String
    func setLoadLabel()
    func firstStartAuth()
    func repeatButtonClick(identifierText: String?)
}
