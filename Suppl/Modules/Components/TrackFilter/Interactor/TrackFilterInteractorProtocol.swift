import Foundation

protocol TrackFilterInteractorProtocol: class {

    func timeCallbackFunc(_ value: inout Float)
    func titleCallbackFunc(_ value: inout Bool)
    func performerCallbackFunc(_ value: inout Bool)
    
}
