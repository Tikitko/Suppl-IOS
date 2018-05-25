import Foundation

protocol TrackFilterPresenterProtocol: class {}

protocol TrackFilterPresenterProtocolInteractor: TrackFilterPresenterProtocol {}

protocol TrackFilterPresenterProtocolView: TrackFilterPresenterProtocol {
    func timeValue() -> Float?
    func titleValue() -> Bool?
    func performerValue() -> Bool?
    
    func timeChange(_ value: inout Float)
    func titleChange(_ value: inout Bool)
    func performerChange(_ value: inout Bool)
}
