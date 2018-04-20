import Foundation
import UIKit
import SwiftTheme

class MainViewController: UIViewController, ControllerInfoProtocol {
    
    public let name = "Музыка"
    public let imageName = "music-7.png"
    
    @IBOutlet weak var tracksSearch: UISearchBar!
    @IBOutlet weak var tracksTable: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    
    private var tracksTableTest: TrackTableViewController!
    
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
        
        loadTable()
        
        let baseQueries = AppStaticData.baseSearchQueriesList
        tracksSearch.text = baseQueries[Int(arc4random_uniform(UInt32(baseQueries.count)))]
        searchTracks(tracksSearch.text ?? "")
    }
    
    private func loadTable() {
        tracksTableTest = TrackTableRouter.setupForMusic(updateCallback: loadMoreCallback(_:))
        tracksTable.addSubview(tracksTableTest.tableView)
        tracksTableTest.tableView.translatesAutoresizingMaskIntoConstraints = false
        tracksTableTest.tableView.topAnchor.constraint(equalTo: tracksTable.topAnchor).isActive = true
        tracksTableTest.tableView.bottomAnchor.constraint(equalTo: tracksTable.bottomAnchor).isActive = true
        tracksTableTest.tableView.leadingAnchor.constraint(equalTo: tracksTable.leadingAnchor).isActive = true
        tracksTableTest.tableView.trailingAnchor.constraint(equalTo: tracksTable.trailingAnchor).isActive = true
        tracksTableTest.tableView.heightAnchor.constraint(equalTo: tracksTable.heightAnchor, multiplier: 1, constant: 1).isActive = true
        tracksTableTest.tableView.widthAnchor.constraint(equalTo: tracksTable.widthAnchor, multiplier: 1, constant: 1).isActive = true
    }
    
    private func loadMoreCallback(_ indexPath: IndexPath) -> Void {
        guard let data = self.searchData else { return }
        if self.inSearchWork { return }
        if data.list.count - 10 == indexPath.row, data.hasMore {
            self.inSearchWork = true
            self.searchTracks(self.thisQuery, offset: data.nextOffset)
        }
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
            updateTable()
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
            self.updateTable()

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
        tracksTableTest.presenter.updateTracks(tracks: searchData?.list ?? [], foundTracks: nil)
        tracksTableTest.tableView.reloadData()
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
        tracksTableTest.tableView.setContentOffset(CGPoint.zero, animated: false)
    }

}
