import Foundation
import UIKit

class TracklistViewController: UIViewController, ControllerInfoProtocol {
    
    public let name = "Плейлист"
    public let imageName = "list-simple-star-7.png"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var tracksTable: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    
    private var tracksTableTest: TrackTableViewController!
    
    private var tracks: [AudioData] = []
    
    private var foundTracks: [AudioData]?
    private var searchByTitle = true
    private var searchByPerformer = true
    private var searchTimeRate: Float = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = name
        loadTable()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTracksNotification(notification:)), name: .TracklistUpdated, object: nil)
        updateTracks()
    }
    
    private func loadTable() {
        tracksTableTest = TrackTableRouter.setupForTracklist()
        tracksTable.addSubview(tracksTableTest.tableView)
        tracksTableTest.tableView.translatesAutoresizingMaskIntoConstraints = false
        tracksTableTest.tableView.topAnchor.constraint(equalTo: tracksTable.topAnchor).isActive = true
        tracksTableTest.tableView.bottomAnchor.constraint(equalTo: tracksTable.bottomAnchor).isActive = true
        tracksTableTest.tableView.leadingAnchor.constraint(equalTo: tracksTable.leadingAnchor).isActive = true
        tracksTableTest.tableView.trailingAnchor.constraint(equalTo: tracksTable.trailingAnchor).isActive = true
        tracksTableTest.tableView.heightAnchor.constraint(equalTo: tracksTable.heightAnchor, multiplier: 1, constant: 1).isActive = true
        tracksTableTest.tableView.widthAnchor.constraint(equalTo: tracksTable.widthAnchor, multiplier: 1, constant: 1).isActive = true
    }

    @objc private func updateTracksNotification(notification: NSNotification) {
        updateTracks()
    }
    
    @IBAction func updateButtonClick(_ sender: Any) {
        clearSearch()
        updateButton.isEnabled = false
        TracklistManager.update() { [weak self] status in
            guard let `self` = self else { return }
            self.updateButton.isEnabled = true
        }
    }
    
    @IBAction func filterButtonClick(_ sender: Any) {
        guard let btn = sender as? UIButton else { return }
        let filterView = TrackFilterViewController()
        filterView.preferredContentSize = CGSize(width: 400, height: 180)
        filterView.modalPresentationStyle = .popover
        let pop = filterView.popoverPresentationController
        pop?.delegate = self
        pop?.sourceView = btn
        pop?.sourceRect = btn.bounds
        present(filterView, animated: true, completion: nil)
        filterView.titleValue(searchByTitle)
        filterView.titleCallback() { [weak self] isOn in
            guard let `self` = self else { return }
            if self.searchByTitle, !self.searchByPerformer { return }
            self.searchByTitle = !self.searchByTitle
        }
        filterView.performerValue(searchByPerformer)
        filterView.performerCallback() { [weak self] isOn in
            guard let `self` = self else { return }
            if self.searchByPerformer, !self.searchByTitle { return }
            self.searchByPerformer = !self.searchByPerformer
        }
        filterView.timeValue(searchTimeRate)
        filterView.timeCallback() { [weak self] value in
            guard let `self` = self else { return }
            
            let offset = 3
            var minRate = 0
            var maxRate = 0
            for track in self.tracks {
                if maxRate < track.duration + offset {
                    maxRate = track.duration + offset
                }
                if minRate == 0 || minRate > track.duration - offset {
                    minRate = track.duration - offset
                }
            }
            self.foundTracks = []
            for track in self.tracks {
                if Float(track.duration - minRate) / Float(maxRate - minRate) < self.searchTimeRate {
                    self.foundTracks?.append(track)
                }
            }
            self.updateTable()
            self.setInfo(self.foundTracks?.count == 0 ? "Ничего не найдено" : nil)
            
            self.searchTimeRate = value
        }
    }
    
    private func clearSearch() {
        searchTimeRate = 1.0
        searchByTitle = true
        searchByPerformer = true
        
        foundTracks = nil
        searchBar.text = ""
    }
    
    private func updateTracks() {
        guard let tracklist = TracklistManager.tracklist else { return }
        if tracklist.count == 0 {
            tracks = []
            updateTable()
            setInfo("Ваш плейлист пуст")
            return
        }
        tracks = []
        recursiveTracksLoad()
    }
    
    private func recursiveTracksLoad(from: Int = 0, packCount count: Int = 10) {
        guard let tracklist = TracklistManager.tracklist else { return }
        let partCount = Int(ceil(Double(tracklist.count) / Double(count))) - 1
        if partCount * count < from {
            updateTable()
            setInfo()
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
    
    private func getTracklistPart(from: Int, count: Int) -> [String] {
        var tracklistPart: [String] = []
        for key in from...from+count-1 {
            guard let tracklist = TracklistManager.tracklist, key < tracklist.count else { break }
            tracklistPart.append(tracklist[key])
        }
        return tracklistPart
    }
    
    private func setInfo(_ text: String? = nil) {
        if let text = text {
            tracksTableTest.tableView.isHidden = true
            infoLabel.text = text
            infoLabel.isHidden = false
        } else {
            tracksTableTest.tableView.isHidden = false
            infoLabel.text = nil
            infoLabel.isHidden = true
        }
    }
    
    private func updateTable() {
        self.tracksTableTest.presenter.updateTracks(tracks: self.tracks, foundTracks: self.foundTracks)
        self.tracksTableTest.tableView.reloadData()
    }
    
}

extension TracklistViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

extension TracklistViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let query = searchBar.text else { return }
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
        updateTable()
        setInfo(foundTracks?.count == 0 ? "Ничего не найдено" : nil)
    }
    
}


