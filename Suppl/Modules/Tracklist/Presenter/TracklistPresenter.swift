import Foundation
import UIKit

class TracklistPresenter: TracklistPresenterProtocol {
    
    var router: TracklistRouterProtocol!
    var interactor: TracklistInteractorProtocol!
    weak var view: TracklistViewControllerProtocol!
    
    var tracks: [AudioData] = []
    
    var nowQuery: String? = nil
    var foundTracks: [AudioData]?
    var searchByTitle = true
    var searchByPerformer = true
    var searchTimeRate: Float = 1.0
    
    func load() {
        interactor.setListener(self)
        interactor.setTracklistListener(self)
        interactor.updateTracks()
    }
    
    func getModuleNameId() -> String {
        return router.moduleNameId
    }
    
    func setInfo(_ text: String? = nil) {
        text != nil ? view.onLabel(text: text!) : view.offLabel()
    }

    func tracklistUpdateResult(status: Bool) {
        view.updateButtonIsEnabled(true)
    }
    
    func filterButtonClick() {
        router.showFilter()
    }
    
    func clearSearch() {
        nowQuery = nil
        searchTimeRate = 1.0
        searchByTitle = true
        searchByPerformer = true
        foundTracks = nil
        view.clearSearch()
    }
    
    func clearTracks() {
        tracks = []
    }
    
    func setNewTrack(track: AudioData) {
        tracks.append(track)
    }
    
    func setUpdateResult(_ status: LocalesManager.Expression?) {
        if let _ = nowQuery {
            searchNowQuery()
        } else {
            view.reloadData()
            setInfo(status != nil ? interactor.getLocaleString(status!) : nil)
        }
    }
    
    func updateButtonClick() {
        clearSearch()
        view.updateButtonIsEnabled(false)
        interactor.tracklistUpdate()
    }
    
    func searchNowQuery() {
        guard let query = nowQuery else { return }
        let lowerQuery = query.lowercased()
        searchTimeRate = 1.0
        foundTracks = []
        for track in tracks {
            var title = false
            var performer = false
            if searchByTitle, track.title.lowercased().range(of: lowerQuery) != nil { title = true }
            if searchByPerformer, track.performer.lowercased().range(of: lowerQuery) != nil { performer = true }
            guard title || performer else { continue }
            foundTracks?.append(track)
        }
        view.reloadData()
        setInfo(foundTracks?.count == 0 ? interactor.getLocaleString(.notFound) : nil)
    }
    
}

extension TracklistPresenter: SearchCommunicateProtocol {
    
    func searchButtonClicked(query: String) {
        nowQuery = query
        searchNowQuery()
    }
    
}

extension TracklistPresenter: TrackFilterCommunicateProtocol {
    
    func timeValue() -> Float {
        return searchTimeRate
    }
    
    func titleValue() -> Bool {
        return searchByTitle
    }
    
    func performerValue() -> Bool {
        return searchByPerformer
    }
    
    func timeChange(_ value: inout Float) {
        searchTimeRate = value
        
        let offset = 3
        var minRate = 0
        var maxRate = 0
        for track in tracks {
            if maxRate < track.duration + offset {
                maxRate = track.duration + offset
            }
            if minRate == 0 || minRate > track.duration - offset {
                minRate = track.duration - offset
            }
        }
        foundTracks = []
        for track in tracks {
            if Float(track.duration - minRate) / Float(maxRate - minRate) < searchTimeRate {
                foundTracks?.append(track)
            }
        }
        view.reloadData()
        setInfo(foundTracks?.count == 0 ? interactor.getLocaleString(.notFound) : nil)
    }
    
    func titleChange(_ value: inout Bool) {
        if searchByTitle, !searchByPerformer {
            value = searchByTitle
            return
        }
        searchByTitle = !searchByTitle
        
    }
    
    func performerChange(_ value: inout Bool) {
        if searchByPerformer, !searchByTitle {
            value = searchByPerformer
            return
        }
        searchByPerformer = !searchByPerformer
    }
    
}

extension TracklistPresenter: TrackTableCommunicateProtocol {
    
    func needTracksForReload() -> [AudioData] {
        return foundTracks ?? tracks
    }
    
    func removedTrack(fromIndex: Int) {}
    
    func addedTrack(withId: String) {}
    
    func moveTrack(from: Int, to: Int) {}
    
    func cellShowAt(_ indexPath: IndexPath) {}

}

extension TracklistPresenter: TracklistListenerDelegate {
    
    func tracklistUpdated(_ tracklist: [String]?) {
        interactor.updateTracks()
    }
    
}
