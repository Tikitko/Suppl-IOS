import Foundation

protocol AuthPresenterProtocol: class {
    func viewDidLoad()
    func viewDidAppear(_ animated: Bool)
    func startAuth(ikey: Int?, akey: Int?)
    func setAuthResult(error: String?)
    func setAuthFormVisable()
    func goToRoot()
    func repeatButtonClick(_ sender: Any, identifierText: String?)
}
