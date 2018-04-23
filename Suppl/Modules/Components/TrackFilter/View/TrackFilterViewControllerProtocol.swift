import Foundation

protocol TrackFilterViewControllerProtocol: class {
    
    func timeValue(_ value: Float)
    func timeIsEnabled(_ isEnabled: Bool)
    func titleValue(_ value: Bool)
    func titleIsEnabled(_ isEnabled: Bool)
    func performerValue(_ value: Bool)
    func performerIsEnabled(_ isEnabled: Bool)
    
}
