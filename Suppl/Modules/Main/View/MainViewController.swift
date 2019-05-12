import Foundation
import UIKit

class MainViewController: ViperOldSafeAreaDefaultView<MainPresenterProtocolView>, MainViewControllerProtocol, ControllerInfoProtocol {
    
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
    
    required init(moduleId: String, args: [String : Any]) {
        tracksTableModule = args["table"] as? UITableViewController
        searchModule = args["search"] as? SearchBarViewController
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = name
        titleLabel.text = name
        view.addSubview(tracksTableModule.tableView)
        tracksTableModule.tableView.includeInside(tracksTable)
        view.addSubview(searchModule.searchBarView)
        searchModule.searchBarView.includeInside(tracksSearch)
        searchModule.searchBarView.placeholder = presenter.getSearchLabel()
        tracksSearch.isHidden = true
        tracksTable.isHidden = true
        setLabel(presenter.getLoadLabel())
        presenter.load()
    }

    override func viewWillAppear(_ animated: Bool) {
        tracksTableModule.viewWillAppear(animated)
        super.viewWillAppear(animated)
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
        searchModule.searchBarView.text = query
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
        guard searchModule.searchBarView.alpha != alphaValue else { return }
        let changes = {
            self.searchModule.searchBarView.alpha = alphaValue
            self.topClearConstraint.isActive = value
            self.view.layoutIfNeeded()
        }
        if animated {
            UIView.performWithoutAnimation {
                self.tracksTableModule.view.layoutIfNeeded()
                self.tracksTableModule.tableView.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.2, animations: changes)
        } else {
            changes()
        }
    }

}
