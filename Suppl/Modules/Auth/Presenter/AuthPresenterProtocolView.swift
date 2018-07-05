import Foundation

protocol AuthPresenterProtocolView: class {
    func getButtonLabel() -> String
    func getResetStackStrings() -> (title: String, field: String, button: String)
    func setLoadLabel()
    func firstStartAuth()
    func userResetKey(_ resetKey: String)
    func requestResetKey(forEmail email: String)
    func repeatButtonClick(identifierText: String?)
}
