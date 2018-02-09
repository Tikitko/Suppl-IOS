import Foundation
import UIKit

class TracklistViewController: UIViewController, ControllerInfoProtocol {
    
    public let name = "Плейлист"
    public let imageName = "list-simple-star-7.png"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var tracksTable: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    
    private var tracks: [AudioData] = []
    private var foundTracks: [AudioData]? = nil
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        navigationItem.title = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tracksTable.register(UINib(nibName: TrackTableCell.identifier, bundle: nil), forCellReuseIdentifier: TrackTableCell.identifier)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTracksNotification(notification:)), name: .TracklistUpdated, object: nil)
        updateTracks()
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
    
    private func clearSearch() {
        foundTracks = nil
        searchBar.text = ""
    }
    
    private func updateTracks() {
        guard let tracklist = TracklistManager.tracklist else { return }
        if tracklist.count == 0 {
            tracks = []
            tracksTable.reloadData()
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
            tracksTable.reloadData()
            setInfo()
            return
        }
        guard let ikey = UserDefaultsManager.identifierKey, let akey = UserDefaultsManager.accessKey else {
            AuthManager.setAuthWindow()
            return
        }
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
            self.tracksTable.isHidden = true
            self.infoLabel.text = text
            self.infoLabel.isHidden = false
        } else {
            self.tracksTable.isHidden = false
            self.infoLabel.text = nil
            self.infoLabel.isHidden = true
        }
    }
    
}

extension TracklistViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let foundTracks = foundTracks {
            return foundTracks.count
        }
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tracksTable.dequeueReusableCell(withIdentifier: TrackTableCell.identifier, for: indexPath) as? TrackTableCell else {
            return UITableViewCell()
        }
        let track = foundTracks != nil ? foundTracks![indexPath.row] : tracks[indexPath.row]
        cell.configure(title: track.title, performer: track.performer, duration: track.duration)
        guard let imageLink = track.images.last, imageLink != "" else { return cell }
        ImagesManager.getImage(link: imageLink) { image in
            guard cell.baseImage else { return }
            cell.configure(image: image)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension TracklistViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Удалить") { [weak self] action, index in
            guard let `self` = self else { return }
            guard let foundTracks = self.foundTracks else {
                TracklistManager.remove(from: index.row) { status in }
                return
            }
            for (key, track) in self.tracks.enumerated() {
                guard track.id == foundTracks[index.row].id else { continue }
                TracklistManager.remove(from: key) { [weak self] status in
                    guard let `self` = self else { return }
                    self.foundTracks?.remove(at: index.row)
                }
                break
            }
        }
        delete.backgroundColor = .red
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var tracksIDs: [String] = []
        for val in tracks {
            tracksIDs.append(val.id)
        }
        let playerView = PlayerViewController(tracksIDs: tracksIDs, current: indexPath.row)
        playerView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(playerView, animated: true)
    }
    
}

extension TracklistViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let query = searchBar.text else { return }
        foundTracks = []
        for track in tracks {
            if (track.title.range(of: query) == nil) && (track.performer.range(of: query) == nil) { continue }
            foundTracks?.append(track)
        }
        tracksTable.reloadData()
        if foundTracks?.count == 0 {
            setInfo("Ничего не найдено")
        }
    }
    
}


