import Foundation
import UIKit
import SwiftTheme

class MainViewController: OldSafeAreaUIViewController, MainViewControllerProtocol, ControllerInfoProtocol {
    
    var presenter: MainPresenterProtocolView!
    
    public lazy var name = {
        return presenter.getTitle()
    }()
    public let image = #imageLiteral(resourceName: "icon_210")
    
    @IBOutlet weak var tracksSearch: UISearchBar!
    @IBOutlet weak var tracksTable: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var tracksTableTest: UITableViewController!
    var searchTest: SearchBarViewController!
    
    lazy var topClearConstraint = tracksTableTest.tableView.topAnchor.constraint(equalTo: searchTest.searchBar.topAnchor, constant: 0)
    
    convenience init(table: UITableViewController, search: SearchBarViewController) {
        self.init()
        tracksTableTest = table
        searchTest = search
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = name
        titleLabel.text = name

        ViewIncludeTemplate.inside(child: tracksTableTest.tableView, parent: tracksTable, includeParent: view)
        ViewIncludeTemplate.inside(child: searchTest.searchBar, parent: tracksSearch, includeParent: view)
        
        searchTest.searchBar.placeholder = presenter.getSearchLabel()
        tracksSearch.isHidden = true
        tracksTable.isHidden = true
        
        setLabel(presenter.getLoadLabel())
        presenter.setListener()
        presenter.loadRandomTracks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tracksTableTest.viewWillAppear(animated)
    }
    
    func reloadData() {
        tracksTableTest.tableView.reloadData()
    }
    
    func setSearchQuery(_ query: String) {
        searchTest.searchBar.text = query
    }
    
    func setLabel(_ text: String?) {
        tracksTableTest.tableView.isHidden = text != nil
        infoLabel.text = text
        infoLabel.isHidden = text == nil
    }
    
    func setOffsetZero() {
        tracksTableTest.tableView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func setHideHeader(_ value: Bool) {
        let alphaValue: CGFloat = value ? 0 : 1
        guard self.searchTest.searchBar.alpha != alphaValue else { return }
        UIView.animate(withDuration: 0.2) {
            self.searchTest.searchBar.alpha = alphaValue
            self.topClearConstraint.isActive = value
            self.view.layoutIfNeeded()
            self.tracksTableTest.view.layoutIfNeeded()
        }
    }

}
