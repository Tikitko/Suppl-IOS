import Foundation

protocol TrackFilterDelegate {
    
    func timeChange(_ value: inout Float)
    func titleChange(_ value: inout Bool)
    func performerChange(_ value: inout Bool)
    
}
