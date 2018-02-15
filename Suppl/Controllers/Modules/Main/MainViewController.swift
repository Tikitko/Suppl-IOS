import Foundation
import UIKit
import SwiftTheme

class MainViewController: UIViewController, ControllerInfoProtocol {
    
    public let name = "Музыка"
    public let imageName = "music-7.png"
    
    @IBOutlet weak var tracksSearch: UISearchBar!
    @IBOutlet weak var tracksTable: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    
    private var searchData: AudioSearchData?
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
        let baseQueries = AppStaticData.baseSearchQueriesList
        tracksSearch.text = baseQueries[Int(arc4random_uniform(UInt32(baseQueries.count)))]
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
        guard let (ikey, akey) = AuthManager.getAuthKeys() else { return }
        inSearchWork = true
        APIManager.audioSearch(ikey: ikey, akey: akey, query: query, offset: offset) { [weak self] error, data in
            defer { self?.inSearchWork = false }
            guard let `self` = self, let data = data else { return }
            self.addFoundTracks(data)
            self.thisQuery = query
            self.tracksTable.reloadData()

        }
    }
    
    private func addFoundTracks(_ data: AudioSearchData) {
        if let _ = searchData {
            for track in data.list {
                searchData?.list.append(track)
            }
            searchData?.nextOffset = data.nextOffset
            searchData?.hasMore = data.hasMore
            searchData?.totalCount = data.totalCount
        } else {
            searchData = data
        }
        if searchData?.list.count == 0 {
            setInfo("Ничего не найдено")
        } else {
            setInfo()
        }
    }
    
    private func setInfo(_ text: String? = nil) {
        if let text = text {
            tracksTable.isHidden = true
            infoLabel.text = text
            infoLabel.isHidden = false
        } else {
            tracksTable.isHidden = false
            infoLabel.text = nil
            infoLabel.isHidden = true
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
                tableView.setEditing(false, animated: true)
                TracklistManager.remove(from: indexTrack) { status in
                    UIAlertController.temporary(lifetime: 0.5, animated: true, title: "Удалено из плейлиста", message: nil, preferredStyle: .alert)
                }
            }
            delete.backgroundColor = .red
            return [delete]
        }
        let add = UITableViewRowAction(style: .normal, title: "Добавить") { action, index in
            tableView.setEditing(false, animated: true)
            TracklistManager.add(trackId: searchData.list[editActionsForRowAt.row].id) { status in
                UIAlertController.temporary(lifetime: 0.5, animated: true, title: "Добавлено в плейлист", message: nil, preferredStyle: .alert)
            }
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
        playerView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(playerView, animated: true)
    }
    
}
