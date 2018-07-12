import Foundation
import UIKit

class TracklistViewController: OldSafeAreaUIViewController, TracklistViewControllerProtocol, ControllerInfoProtocol {
    
    var presenter: TracklistPresenterProtocolView!
    
    public lazy var name = {
        return presenter.getTitle()
    }()
    public let image = #imageLiteral(resourceName: "icon_204")
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var tracksTable: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var tracksTableTest: UITableViewController!
    var searchTest: SearchBarViewController!
    
    var buttonsIsOff = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
        updateButton.setImage(#imageLiteral(resourceName: "icon_020").withRenderingMode(.alwaysTemplate), for: .normal)
        filterButton.setImage(#imageLiteral(resourceName: "icon_141").withRenderingMode(.alwaysTemplate), for: .normal)
        editButton.setImage(#imageLiteral(resourceName: "icon_166").withRenderingMode(.alwaysTemplate), for: .normal)
        
        navigationItem.title = name
        titleLabel.text = name
        
        ViewIncludeTemplate.inside(child: tracksTableTest.tableView, parent: tracksTable, includeParent: view)
        ViewIncludeTemplate.inside(child: searchTest.searchBar, parent: searchBar, includeParent: view)
        searchTest.searchBar.placeholder = presenter.getSearchLabel()
        searchBar.isHidden = true
        tracksTable.isHidden = true
        
        setLabel(presenter.getLoadLabel())
        presenter.load()
    }
    
    func setTheme() {
        updateButton.theme_tintColor = "secondColor"
        filterButton.theme_tintColor = "secondColor"
        editButton.theme_tintColor = "secondColor"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tracksTableTest.viewWillAppear(animated)
    }
    
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
    
    func reloadData() {
        editButton.isEnabled = presenter.getEditPermission() && !buttonsIsOff
        if !editButton.isEnabled, tracksTableTest.isEditing {
            tracksTableTest.setEditing(false, animated: true)
        }
        tracksTableTest.tableView.reloadData()
    }
    
    func clearSearch() {
        searchTest.searchBar.text = nil
    }
    
    func offButtons() {
        buttonsIsOff = true
        editButton.isEnabled = false
    }
    
    func setLabel(_ text: String?) {
        tracksTableTest.tableView.isHidden = text != nil
        infoLabel.text = text
        infoLabel.isHidden = text == nil
    }
    
    func updateButtonIsEnabled(_ value: Bool) {
        updateButton.isEnabled = value
    }
    
    func setFilterThenPopover(filterController: UIViewController){
        filterController.preferredContentSize = CGSize(width: 400, height: 180)
        filterController.modalPresentationStyle = .popover
        let pop = filterController.popoverPresentationController
        pop?.delegate = self
        pop?.sourceView = filterButton
        pop?.sourceRect = filterButton.bounds
    }
    
    @IBAction func updateButtonClick(_ sender: Any) {
        presenter.updateButtonClick()
    }
    
    @IBAction func filterButtonClick(_ sender: Any) {
        presenter.filterButtonClick()
    }
    
    @IBAction func editButtonClick(_ sender: Any) {
        tracksTableTest.setEditing(!tracksTableTest.isEditing, animated: true)
    }
    
}

extension TracklistViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

