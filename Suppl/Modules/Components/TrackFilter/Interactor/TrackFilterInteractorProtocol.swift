import Foundation

protocol TrackFilterInteractorProtocol: class {
    
    func timeCallbackSet(_ timeCallback: ((_: inout Float) -> Void)?)
    func titleCallbackSet(_ titleCallback: ((_: inout Bool) -> Void)?)
    func performerCallbackSet(_ performerCallback: ((_: inout Bool) -> Void)?)
    
    func timeCallbackFunc(_ value: inout Float)
    func titleCallbackFunc(_ value: inout Bool)
    func performerCallbackFunc(_ value: inout Bool)
    
}
