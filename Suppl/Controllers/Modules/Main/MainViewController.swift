import Foundation
import UIKit

class MainViewController: UIViewController, ControllerInfoProtocol {
    
    public let name = "Музыка"
    public let imageName = "music-7.png"
    
    @IBOutlet weak var tracksSearch: UISearchBar!
    @IBOutlet weak var tracksTable: UITableView!
    
    private struct Track {
        let data: AudioData
        var image: UIImage?
        init(_ data: AudioData) {
            self.data = data
            self.image = nil
        }
    }
    private var tracks: [Track] = []
    private var hasMore = false
    private var nextOffset = 0
    private var thisQuery = String()
    
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
        tracksSearch.text = String()
        searchTracks(tracksSearch.text ?? String())
    }
    
    private func clearData() {
        tracks = []
        hasMore = false
        nextOffset = 0
        thisQuery = String()
        tracksTable.reloadData()
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
            self.hasMore = data.hasMore
            self.nextOffset = data.nextOffset
            self.thisQuery = query
            for track in data.list {
                self.tracks.append(Track(track))
            }
            self.tracksTable.reloadData()
        }
        
    }
    
    private func imageLoader(link: String, cell: TrackTableCell, index: Int) {
        APIManager.API.request(url: link, inMain: true) { [weak self] error, response, data in
            guard let `self` = self,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
                else { return }
            cell.configure(image: image)
            self.tracks[index].image = image
        }
    }

}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = tracksSearch.text else { return }
        clearData()
        searchTracks(query)
        tracksTable.setContentOffset(CGPoint.zero, animated: false)
    }

}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tracksTable.dequeueReusableCell(withIdentifier: TrackTableCell.identifier, for: indexPath) as? TrackTableCell else {
            return UITableViewCell()
        }
        let track = tracks[indexPath.row]
        cell.configure(title: track.data.title, performer: track.data.performer)
        guard let imageLink = track.data.images.last, imageLink != String() else { return cell }
        if let image = tracks[indexPath.row].image {
            cell.configure(image: image)
        } else {
            imageLoader(link: imageLink, cell: cell, index: indexPath.row)
        }
        return cell
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if inSearchWork { return }
        if tracks.count - 10 == indexPath.row, hasMore {
            inSearchWork = true
            searchTracks(thisQuery, offset: nextOffset)
        }
    }
    
}
