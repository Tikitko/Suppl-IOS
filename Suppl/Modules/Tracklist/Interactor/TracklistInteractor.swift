import Foundation

class TracklistInteractor: TracklistInteractorProtocol {
    
    weak var presenter: TracklistPresenterProtocol!
    
    var reloadData: ((_ tracks: [AudioData], _ foundTracks: [AudioData]?) -> Void)!
    
    var tracks: [AudioData] = []
    
    var foundTracks: [AudioData]?
    var searchByTitle = true
    var searchByPerformer = true
    var searchTimeRate: Float = 1.0
    
    func load() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTracksNotification(notification:)), name: .TracklistUpdated, object: nil)
        updateTracks()
    }
    
    func createFilterListeners(name: String) {
        /*
        NotificationManager.addListener(name, inSection: "FilterTitleCallback", callback: titleCallback)
        NotificationManager.addListener(name, inSection: "FilterPerformerCallback", callback: performerCallback)
        NotificationManager.addListener(name, inSection: "FilterTimeCallback", callback: timeCallback)
         */
    }
    
    func titleCallback(_ value: Any?) {
        guard let isOn = value as? Bool else { return }
        searchByTitle = isOn
    }
    
    func performerCallback(_ value: Any?) {
        guard let isOn = value as? Bool else { return }
        searchByPerformer = isOn
    }
    
    func timeCallback(_ value: Any?) {
        guard let value = value as? Float else { return }
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
        updateTable()
        presenter.setInfo(foundTracks?.count == 0 ? "Ничего не найдено" : nil)
    }
    
    func clearSearch() {
        searchTimeRate = 1.0
        searchByTitle = true
        searchByPerformer = true
        
        foundTracks = nil
        presenter.clearSearch()
    }
    
    func updateTracks() {
        guard let tracklist = TracklistManager.tracklist else { return }
        if tracklist.count == 0 {
            tracks = []
            updateTable()
            presenter.setInfo("Ваш плейлист пуст")
            return
        }
        tracks = []
        recursiveTracksLoad()
    }
    
    func recursiveTracksLoad(from: Int = 0, packCount count: Int = 10) {
        guard let tracklist = TracklistManager.tracklist else { return }
        let partCount = Int(ceil(Double(tracklist.count) / Double(count))) - 1
        if partCount * count < from {
            updateTable()
            presenter.setInfo(nil)
            return
        }
        guard let (ikey, akey) = AuthManager.getAuthKeys() else { return }
        let tracklistPart = getTracklistPart(from: from, count: count)
        APIManager.audioGet(ikey: ikey, akey: akey, ids: tracklistPart.joined(separator: ",")) { [weak self] error, data in
            guard let `self` = self, let data = data else { return }
            for track in data.list {
                self.tracks.append(track)
            }
            self.recursiveTracksLoad(from: from + count)
        }
    }
    
    func getTracklistPart(from: Int, count: Int) -> [String] {
        var tracklistPart: [String] = []
        for key in from...from+count-1 {
            guard let tracklist = TracklistManager.tracklist, key < tracklist.count else { break }
            tracklistPart.append(tracklist[key])
        }
        return tracklistPart
    }
    
    func updateTable() {
        reloadData(tracks, foundTracks)
    }
    
    func searchBarSearchButtonClicked(searchText: String) {
        let lowerQuery = searchText.lowercased()
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
        updateTable()
        presenter.setInfo(foundTracks?.count == 0 ? "Ничего не найдено" : nil)
    }
    
    func updateButtonClick() {
        clearSearch()
        presenter.updateButtonIsEnabled(false)
        TracklistManager.update() { [weak self] status in
            guard let `self` = self else { return }
            self.presenter.updateButtonIsEnabled(true)
        }
    }
    
    @objc private func updateTracksNotification(notification: NSNotification) {
        updateTracks()
    }
    
}
