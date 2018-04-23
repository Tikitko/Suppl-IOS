import Foundation
import UIKit
import SwiftTheme

class MainViewController: UIViewController, MainViewControllerProtocol, ControllerInfoProtocol {
    
    var presenter: MainPresenterProtocol!
    
    public let name = "Музыка"
    public let imageName = "music-7.png"
    
    @IBOutlet weak var tracksSearch: UISearchBar!
    @IBOutlet weak var tracksTable: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var tracksTableTest: UITableViewController!
    
    convenience init(table: UITableViewController) {
        self.init()
        tracksTableTest = table
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = name
        includeTable()
        presenter.load()
    }
    
    func setSearchQuery(_ query: String) {
        tracksSearch.text = query
    }
    
    func includeTable() {
        tracksTable.addSubview(tracksTableTest.tableView)
        tracksTableTest.tableView.translatesAutoresizingMaskIntoConstraints = false
        tracksTableTest.tableView.topAnchor.constraint(equalTo: tracksTable.topAnchor).isActive = true
        tracksTableTest.tableView.bottomAnchor.constraint(equalTo: tracksTable.bottomAnchor).isActive = true
        tracksTableTest.tableView.leadingAnchor.constraint(equalTo: tracksTable.leadingAnchor).isActive = true
        tracksTableTest.tableView.trailingAnchor.constraint(equalTo: tracksTable.trailingAnchor).isActive = true
        tracksTableTest.tableView.heightAnchor.constraint(equalTo: tracksTable.heightAnchor, multiplier: 1, constant: 1).isActive = true
        tracksTableTest.tableView.widthAnchor.constraint(equalTo: tracksTable.widthAnchor, multiplier: 1, constant: 1).isActive = true
    }
    
    func onLabel(text: String) {
        tracksTableTest.tableView.isHidden = true
        infoLabel.text = text
        infoLabel.isHidden = false
    }
    
    func offLabel() {
        tracksTableTest.tableView.isHidden = false
        infoLabel.text = nil
        infoLabel.isHidden = true
    }
    
    func setOffsetZero() {
        tracksTableTest.tableView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    deinit {
        presenter.unload()
    }

}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let query = tracksSearch.text else { return }
        presenter.searchBarSearchButtonClicked(searchText: query)
    }

}
