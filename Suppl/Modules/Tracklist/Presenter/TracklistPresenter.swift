import Foundation
import UIKit

class TracklistPresenter: ViperPresenter<TracklistRouterProtocol, TracklistInteractorProtocol, TracklistViewControllerProtocol>, TracklistPresenterProtocolInteractor, TracklistPresenterProtocolView {
    
    var tracks: [AudioData] = []
    
    var nowQuery: String?
    var foundTracks: [AudioData]?
    var searchByTitle = true
    var searchByPerformer = true
    var searchTimeRate: Float = 1
    var updateTrysCount = 0
    
    let moduleNameId: String
    
    required init(moduleId: String, parentModuleId: String?, args: [String : Any]) {
        moduleNameId = moduleId
        super.init()
    }
    
    var canHideLogo: Bool? {
        didSet {
            if canHideLogo == nil { return }
            view.setHideHeader(false, animated: false)
        }
    }
    
    func getTitle() -> String {
        return "tracklistTitle".localizeKey
    }
    
    func getLoadLabel() -> String {
        return "load".localizeKey
    }
    
    func getSearchLabel() -> String {
        return "searchTracklist".localizeKey
    }
    
    func load() {
        interactor.requestOfflineStatus()
        interactor.setListener(self)
        interactor.setTracklistListener(self)
        interactor.listenSettings()
        interactor.requestHideLogoSetting()
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
    
    func setUpdateResult(localizationKey: String?) {
        if let _ = nowQuery {
            searchNowQuery()
        } else {
            view.reloadData()
            interactor.saveTracks(tracks)
            setInfo(localizationKey?.localizeKey)
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
        setInfo(foundTracks?.count == 0 ? "notFound".localizeKey : nil)
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
            setInfo(foundTracks?.count == 0 ? "notFound".localizeKey : nil)
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
    
    func requestConfigure() -> TableConfigure {
        return TableConfigure(
            light: false,
            smallCells: nil,
            downloadButtons: true,
            followTrack: (false, false)
        )
    }
    
    func needTracksForReload() -> [AudioData] {
        return foundTracks ?? tracks
    }
    
    func zoneRangePassed(toTop: Bool) {
        guard canHideLogo ?? false else { return }
        view.setHideHeader(!toTop, animated: true)
    }

}

extension TracklistPresenter: TracklistListenerDelegate {
    
    func tracklistUpdated(_ tracklist: [String]?) {
        interactor.updateTracks()
    }
    
}
