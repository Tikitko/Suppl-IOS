import Foundation
import UIKit

class MainViewController: UIViewController, ControllerInfoProtocol {
    
    public let name = "Музыка"
    public let imageName = "music-7.png"
    
    @IBOutlet weak var tracksSearch: UISearchBar!
    @IBOutlet weak var tracksTable: UITableView!
    
    private let baseSearchQueries = [
        "Pink Floyd",
        "Led Zeppelin",
        "Rolling Stones",
        "Queen",
        "Nirvana",
        "The Beatles",
        "Metallica",
        "Bon Jovi",
        "AC/DC",
        "Red Hot Chili Peppers"
    ]
    
    private var searchData: AudioSearchData? = nil
    private var thisQuery = ""
    
    private var inSearchWork = false
    
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
        tracksTable.reloadData()
        tracksSearch.text = baseSearchQueries[Int(arc4random_uniform(UInt32(baseSearchQueries.count)))]
        searchTracks(tracksSearch.text ?? "")
    }
    
    private func clearData(withReload: Bool = true) {
        if let searchData = searchData {
            for track in searchData.list {
                guard let link = track.images.last else { continue }
                ImagesManager.removeFromCache(link: link)
            }
        }
        searchData = nil
        thisQuery = ""
        if withReload {
            tracksTable.reloadData()
        }
    }
    
    private func searchTracks(_ query: String, offset: Int = 0) {
        guard let ikey = UserDefaultsManager.identifierKey, let akey = UserDefaultsManager.accessKey else {
            AuthManager.setAuthWindow()
            return
        }
        inSearchWork = true
        APIManager.audioSearch(ikey: ikey, akey: akey, query: query, offset: offset) { [weak self] error, data in
            defer { self?.inSearchWork = false }
            guard let `self` = self, let data = data else { return }
            if let _ = self.searchData {
                for track in data.list {
                    self.searchData?.list.append(track)
                }
                self.searchData?.nextOffset = data.nextOffset
                self.searchData?.hasMore = data.hasMore
                self.searchData?.totalCount = data.totalCount
            } else {
                self.searchData = data
            }
            self.thisQuery = query
            self.tracksTable.reloadData()
        }
    }
    
    deinit {
        clearData(withReload: false)
    }

}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let query = tracksSearch.text else { return }
        clearData()
        searchTracks(query)
        tracksTable.setContentOffset(CGPoint.zero, animated: false)
    }

}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tracksTable.dequeueReusableCell(withIdentifier: TrackTableCell.identifier, for: indexPath) as? TrackTableCell, let data = searchData else {
            return UITableViewCell()
        }
        let track = data.list[indexPath.row]
        cell.configure(title: track.title, performer: track.performer, duration: track.duration)
        guard let imageLink = track.images.last, imageLink != "" else { return cell }
        ImagesManager.getImage(link: imageLink) { image in
            guard cell.baseImage else { return }
            cell.configure(image: image)
        }
        return cell
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let data = searchData else { return }
        if inSearchWork { return }
        if data.list.count - 10 == indexPath.row, data.hasMore {
            inSearchWork = true
            searchTracks(thisQuery, offset: data.nextOffset)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        guard let tracklist = TracklistManager.tracklist, let searchData = searchData else { return [] }
        if let indexTrack = tracklist.index(of: searchData.list[editActionsForRowAt.row].id) {
            let delete = UITableViewRowAction(style: .normal, title: "Удалить") { action, index in
                TracklistManager.remove(from: indexTrack) { status in }
            }
            delete.backgroundColor = .red
            return [delete]
        }
        let add = UITableViewRowAction(style: .normal, title: "Добавить") { action, index in
            TracklistManager.add(trackId: searchData.list[editActionsForRowAt.row].id) { status in }
        }
        add.backgroundColor = .green
        return [add]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tracks = searchData?.list else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        var tracksIDs: [String] = []
        for val in tracks {
            tracksIDs.append(val.id)
        }
        let playerView = PlayerViewController(tracksIDs: tracksIDs, current: indexPath.row)
        navigationController?.pushViewController(playerView, animated: true)
    }
    
}
