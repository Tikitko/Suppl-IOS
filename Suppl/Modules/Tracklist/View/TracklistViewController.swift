import Foundation
import UIKit

class TracklistViewController: UIViewController, TracklistViewControllerProtocol, ControllerInfoProtocol {
    
    var presenter: TracklistPresenterProtocol!
    
    public let name: String = LocalesManager.s.get(.tracklistTitle)
    public let imageName = "list-simple-star-7.png"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var tracksTable: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    
    var tracksTableTest: UITableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = name
        ConstraintConstructor.includeView(child: tracksTableTest.tableView, parent: tracksTable)
        presenter.load()
    }
    
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
    
    func clearSearch() {
        searchBar.text = ""
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
    
    @IBAction func updateButtonClick(_ sender: Any) {
        presenter.updateButtonClick()
    }
    
    @IBAction func filterButtonClick(_ sender: Any) {
        presenter.filterButtonClick(sender)
    }
    
}

extension TracklistViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

extension TracklistViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        guard let query = searchBar.text else { return }
        presenter.searchBarSearchButtonClicked(searchText: query)
    }
    
}

extension TracklistViewController: TrackFilterDelegate {
    
    func timeChange(_ value: inout Float) {
        presenter.timeChange(&value)
    }
    
    func titleChange(_ value: inout Bool) {
        presenter.titleChange(&value)
    }
    
    func performerChange(_ value: inout Bool) {
        presenter.performerChange(&value)
    }
    
}


