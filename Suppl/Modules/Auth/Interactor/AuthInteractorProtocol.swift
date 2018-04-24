import Foundation

protocol AuthInteractorProtocol: class {
    var noAuthOnShow: Bool { get }
    func endAuth()
    func auth(ikey: Int?, akey: Int?)
    func reg()
    func inputProcessing(input: String?) -> Bool
}
