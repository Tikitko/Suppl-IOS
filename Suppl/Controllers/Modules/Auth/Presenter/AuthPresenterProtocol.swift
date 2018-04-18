import Foundation

protocol AuthPresenterProtocol: class {
    func viewDidLoad()
    func viewDidAppear()
    func startAuth(ikey: Int?, akey: Int?)
    func setAuthResult(error: String?)
    func setAuthFormVisable()
    func goToRoot()
    func repeatButtonClick(_ sender: Any, identifierText: String?)
}
