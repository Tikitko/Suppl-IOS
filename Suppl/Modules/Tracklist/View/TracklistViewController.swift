import Foundation
import UIKit

class TracklistViewController: ViperOldSafeAreaDefaultView<TracklistPresenterProtocolView>, TracklistViewControllerProtocol, ControllerInfoProtocol {
    
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
    
    var tracksTableModule: UITableViewController!
    var searchModule: SearchBarViewController!
    
    lazy var topClearConstraint = tracksTableModule.tableView.topAnchor.constraint(equalTo: searchBar.topAnchor, constant: 0)
    
    var buttonsIsOff = false
    
    override func viewDidLoad() {
        tracksTableModule = presenter.createTrackTableModule()
        searchModule = presenter.createSearchBarModule()
        super.viewDidLoad()
        setTheme()
        updateButton.setImage(#imageLiteral(resourceName: "icon_020").withRenderingMode(.alwaysTemplate), for: .normal)
        filterButton.setImage(#imageLiteral(resourceName: "icon_141").withRenderingMode(.alwaysTemplate), for: .normal)
        editButton.setImage(#imageLiteral(resourceName: "icon_166").withRenderingMode(.alwaysTemplate), for: .normal)
        navigationItem.title = name
        titleLabel.text = name
        view.addSubview(tracksTableModule.tableView)
        tracksTableModule.tableView.includeInside(tracksTable)
        view.addSubview(searchModule.searchBarView)
        searchModule.searchBarView.includeInside(searchBar)
        searchModule.searchBarView.placeholder = presenter.getSearchLabel()
        searchBar.isHidden = true
        tracksTable.isHidden = true
        setLabel(presenter.getLoadLabel())
        presenter.load()
    }
    
    func setTheme() {
        updateButton.theme_tintColor = UIColor.Theme.second.picker
        filterButton.theme_tintColor = UIColor.Theme.second.picker
        editButton.theme_tintColor = UIColor.Theme.second.picker
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
        editButton.isEnabled = presenter.getEditPermission() && !buttonsIsOff
        if !editButton.isEnabled, tracksTableModule.isEditing {
            tracksTableModule.setEditing(false, animated: true)
        }
        tracksTableModule.tableView.reloadData()
    }
    
    func clearSearch() {
        searchModule.searchBarView.text = nil
    }
    
    func offButtons() {
        buttonsIsOff = true
        editButton.isEnabled = false
    }
    
    func setLabel(_ text: String?) {
        tracksTableModule.tableView.isHidden = text != nil
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
    
    func setHideHeader(_ value: Bool, animated: Bool = false) {
        let alphaValue: CGFloat = value ? 0 : 1
        guard self.searchModule.searchBarView.alpha != alphaValue else { return }
        let changes = {
            self.searchModule.searchBarView.alpha = alphaValue
            self.topClearConstraint.isActive = value
            self.filterButton.alpha = alphaValue
            self.updateButton.alpha = alphaValue
            self.editButton.alpha = alphaValue
            self.view.layoutIfNeeded()
            self.tracksTableModule.view.layoutIfNeeded()
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
    
    @IBAction func updateButtonClick(_ sender: Any) {
        presenter.updateButtonClick()
    }
    
    @IBAction func filterButtonClick(_ sender: Any) {
        presenter.filterButtonClick()
    }
    
    @IBAction func editButtonClick(_ sender: Any) {
        tracksTableModule.setEditing(!tracksTableModule.isEditing, animated: true)
    }
    
}

extension TracklistViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

