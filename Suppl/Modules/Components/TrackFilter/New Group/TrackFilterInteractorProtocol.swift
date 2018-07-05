import Foundation

protocol TrackFilterInteractorProtocol: class, BaseInteractorProtocol {
    var communicateDelegate: TrackFilterCommunicateProtocol? { get }
}
