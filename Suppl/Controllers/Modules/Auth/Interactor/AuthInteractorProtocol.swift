import Foundation

protocol AuthInteractorProtocol: class {
    var noAuthOnShow: Bool { get }
    func getKeys() -> (i: Int, a: Int)?
    func endAuth()
    func auth(ikey: Int, akey: Int)
    func reg()
    func inputProcessing(input: String?) -> (ikey: Int, akey: Int)?
}
