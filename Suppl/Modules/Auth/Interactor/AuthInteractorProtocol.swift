import Foundation

protocol AuthInteractorProtocol: class {
    var noAuthOnShow: Bool { get }
    func endAuth()
    func auth(keys: KeysPair?)
    func reg()
    func inputProcessing(input: String?) -> Bool
}
