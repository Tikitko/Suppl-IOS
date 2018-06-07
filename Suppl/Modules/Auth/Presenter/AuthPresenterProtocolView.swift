import Foundation

protocol AuthPresenterProtocolView: class {
    func setLoadLabel()
    func firstStartAuth()
    func repeatButtonClick(identifierText: String?)
}
