import Foundation

protocol TracklistListenerDelegate: class {
    func tracklistUpdated(_ tracklist: [String]?)
}
