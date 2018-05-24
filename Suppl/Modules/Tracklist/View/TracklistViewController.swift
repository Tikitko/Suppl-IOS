import Foundation
import UIKit

class TracklistViewController: UIViewController, TracklistViewControllerProtocol, ControllerInfoProtocol {
    
    var presenter: TracklistPresenterProtocol!
    
    public let name: String = LocalesManager.s.get(.tracklistTitle)
    public let imageName: String = "list-simple-star-7.png"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var tracksTable: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var tracksTableTest: UITableViewController!
    var searchTest: SearchBarViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = name
        
        ViewIncludeTemplate.inside(child: tracksTableTest.tableView, parent: tracksTable, includeParent: view)
        ViewIncludeTemplate.inside(child: searchTest.searchBar, parent: searchBar, includeParent: view)
        searchTest.searchBar.placeholder = searchBar.placeholder
        searchBar.isHidden = true
        tracksTable.isHidden = true
        
        onLabel(text: infoLabel.text ?? "")
        
        presenter.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tracksTableTest.tableView.reloadData()
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
        tracksTableTest.tableView.reloadData()
    }
    
    func clearSearch() {
        searchTest.searchBar.text = ""
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
        tracksTableTest.isEditing = !tracksTableTest.isEditing
    }
    
}

extension TracklistViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

