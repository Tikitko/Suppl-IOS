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
    
    var tracksTableModule: UITableViewController!
    var searchModule: SearchBarViewController!
    
    lazy var topClearConstraint = tracksTableModule.tableView.topAnchor.constraint(equalTo: tracksSearch.topAnchor, constant: 0)
    
    convenience init(table: UITableViewController, search: SearchBarViewController) {
        self.init()
        tracksTableModule = table
        searchModule = search
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

        ViewIncludeTemplate.inside(child: tracksTableModule.tableView, parent: tracksTable, includeParent: view)
        ViewIncludeTemplate.inside(child: searchModule.searchBar, parent: tracksSearch, includeParent: view)
        
        searchModule.searchBar.placeholder = presenter.getSearchLabel()
        tracksSearch.isHidden = true
        tracksTable.isHidden = true
        
        setLabel(presenter.getLoadLabel())
        presenter.load()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tracksTableModule.viewWillAppear(animated)
        //setHideHeader(false, animated: false)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        switch traitCollection.verticalSizeClass {
        case .regular: topClearConstraint.constant = 5
        case .compact: topClearConstraint.constant = 0
        default: break
        }
    }
    
    func reloadData() {
        tracksTableModule.tableView.reloadData()
    }
    
    func setSearchQuery(_ query: String) {
        searchModule.searchBar.text = query
    }
    
    func setLabel(_ text: String?) {
        tracksTableModule.tableView.isHidden = text != nil
        infoLabel.text = text
        infoLabel.isHidden = text == nil
    }
    
    func setOffsetZero() {
        tracksTableModule.tableView.setContentOffset(.zero, animated: false)
    }
    
    func setHideHeader(_ value: Bool, animated: Bool = false) {
        let alphaValue: CGFloat = value ? 0 : 1
        guard searchModule.searchBar.alpha != alphaValue else { return }
        let changes = {
            self.searchModule.searchBar.alpha = alphaValue
            self.topClearConstraint.isActive = value
            self.view.layoutIfNeeded()
        }
        animated ? UIView.animate(withDuration: 0.2, animations: changes) : changes()
    }

}
