import Foundation
import UIKit

class TracklistViewController: UIViewController, ControllerInfoProtocol {
    
    public let name = "Плейлист"
    public let imageName = "list-simple-star-7.png"
    

    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var tracksTable: UITableView!
    
    private var tracks: [AudioData] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @objc private func updateTracksNotification(notification: NSNotification) {
        updateTracks()
    }
    
    @IBAction func updateButtonClick(_ sender: Any) {
        updateButton.isEnabled = false
        TracklistManager.update() { [weak self] status in
            guard let `self` = self else { return }
            self.updateButton.isEnabled = true
        }
    }
    
    private func updateTracks() {
        guard let ikey = UserDefaultsManager.identifierKey, let akey = UserDefaultsManager.accessKey else {
            AuthManager.setAuthWindow()
            return
        }
        guard let tracklist = TracklistManager.tracklist else { return }
        if tracklist.count == 0 {
            self.tracks = []
            self.tracksTable.reloadData()
        }
        APIManager.audioGet(ikey: ikey, akey: akey, ids: tracklist.joined(separator: ",")) { [weak self] error, data in
            guard let `self` = self, let data = data else { return }
            self.tracks = data.list
            self.tracksTable.reloadData()
        }
    }
}

extension TracklistViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tracksTable.dequeueReusableCell(withIdentifier: TrackTableCell.identifier, for: indexPath) as? TrackTableCell else {
            return UITableViewCell()
        }
        let track = tracks[indexPath.row]
        cell.configure(title: track.title, performer: track.performer)
        guard let imageLink = track.images.last, imageLink != String() else { return cell }
        ImagesManager.getImage(link: imageLink) { image in
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
        let delete = UITableViewRowAction(style: .normal, title: "Удалить") { action, index in
            TracklistManager.remove(from: index.row) { status in
            }
        }
        delete.backgroundColor = .red
        return [delete]
    }
    
}

extension TracklistViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}


