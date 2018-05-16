import Foundation
import UIKit
import SwiftTheme

class MainViewController: UIViewController, MainViewControllerProtocol, ControllerInfoProtocol {
    
    var presenter: MainPresenterProtocol!
    
    public let name: String = LocalesManager.s.get(.musicTitle)
    public let imageName = "music-7.png"
    
    @IBOutlet weak var tracksSearch: UISearchBar!
    @IBOutlet weak var tracksTable: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var tracksTableTest: UITableViewController!
    var searchTest: UISearchBar!
    
    convenience init(table: UITableViewController, search: UISearchBar) {
        self.init()
        tracksTableTest = table
        searchTest = search
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
        
        ViewIncludeTemplate.inside(child: tracksTableTest.tableView, parent: tracksTable)
        ViewIncludeTemplate.inside(child: searchTest, parent: tracksSearch)
        searchTest.placeholder = tracksSearch.placeholder
        
        presenter.setListener()
        presenter.loadRandomTracks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tracksTableTest.tableView.reloadData()
    }
    
    func reloadData() {
        tracksTableTest.tableView.reloadData()
    }
    
    func setSearchQuery(_ query: String) {
        searchTest.text = query
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

}
