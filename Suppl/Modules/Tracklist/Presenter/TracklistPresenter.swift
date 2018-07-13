import Foundation
import UIKit

class TracklistPresenter: TracklistPresenterProtocolInteractor, TracklistPresenterProtocolView {
    
    var router: TracklistRouterProtocol!
    var interactor: TracklistInteractorProtocol!
    weak var view: TracklistViewControllerProtocol!
    
    var tracks: [AudioData] = []
    
    var nowQuery: String? = nil
    var foundTracks: [AudioData]?
    var searchByTitle = true
    var searchByPerformer = true
    var searchTimeRate: Float = 1.0
    var updateTrysCount = 0
    
    var moduleNameId: String {
        get { return router.moduleNameId }
    }
    
    func getTitle() -> String {
        return interactor.getLocaleString(.tracklistTitle)
    }
    
    func getLoadLabel() -> String {
        return interactor.getLocaleString(.load)
    }
    
    func getSearchLabel() -> String {
        return interactor.getLocaleString(.searchTracklist)
    }
    
    func load() {
        interactor.requestOfflineStatus()
        interactor.setListener(self)
        interactor.setTracklistListener(self)
        interactor.updateTracks()
    }
    
    func setInfo(_ text: String? = nil) {
        view.setLabel(text)
    }

    func tracklistUpdateResult(status: Bool) {
        view.updateButtonIsEnabled(true)
    }
    
    func offlineStatus(_ isOn: Bool) {
        guard isOn else { return }
        view.offButtons()
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
    
    func getEditPermission() -> Bool {
        return foundTracks == nil
    }
    
    func clearTracks() {
        tracks = []
    }
    
    func setNewTrack(_ track: AudioData) {
        tracks.append(track)
    }
    
    func setUpdateResult(_ status: LocalesManager.Expression?) {
        if let _ = nowQuery {
            searchNowQuery()
        } else {
            view.reloadData()
            interactor.saveTracks(tracks)
            setInfo(status != nil ? interactor.getLocaleString(status!) : nil)
        }
    }
    
    func updateButtonClick() {
        setInfo(getLoadLabel())
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
        updateTrysCount += 1
        if updateTrysCount != 1 {
            if updateTrysCount >= 8 {
                updateTrysCount = 0
            }
            return
        }
        
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
        if value == 1 {
            foundTracks = nil
        } else {
            setInfo(foundTracks?.count == 0 ? interactor.getLocaleString(.notFound) : nil)
        }
        view.reloadData()
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
    
    func zoneRangePassed(toTop: Bool) {
        view.setHideHeader(!toTop)
    }

}

extension TracklistPresenter: TracklistListenerDelegate {
    
    func tracklistUpdated(_ tracklist: [String]?) {
        interactor.updateTracks()
    }
    
}
