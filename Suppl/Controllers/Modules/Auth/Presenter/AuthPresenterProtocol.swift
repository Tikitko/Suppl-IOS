import Foundation

protocol AuthPresenterProtocol {
    func viewDidLoad()
    func viewDidAppear(_ animated: Bool)
    func startAuth(ikey: Int?, akey: Int?)
    func auth(ikey: Int, akey: Int)
    func register()
    func setResult(error: String?)
    func setAuthFormVisable()
    func goToRoot()
    func repeatButtonClick(_ sender: Any, identifierText: String?)
}
