import Foundation

protocol TrackFilterPresenterProtocol: class {
    
    func timeIsEnabled(_ isEnabled: Bool)
    func titleIsEnabled(_ isEnabled: Bool)
    func performerIsEnabled(_ isEnabled: Bool)
    
    func timeCallbackSet(_ timeCallback: @escaping ((_: inout Float) -> Void))
    func titleCallbackSet(_ titleCallback: @escaping ((_: inout Bool) -> Void))
    func performerCallbackSet(_ performerCallback: @escaping ((_: inout Bool) -> Void))
    
    func timeCallbackFunc(_ value: inout Float)
    func titleCallbackFunc(_ value: inout Bool)
    func performerCallbackFunc(_ value: inout Bool)
    
}
