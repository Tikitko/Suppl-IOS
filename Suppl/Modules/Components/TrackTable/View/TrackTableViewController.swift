import Foundation
import UIKit

final class TrackTableViewController: UITableViewController, TrackTableViewControllerProtocol {
    var presenter: TrackTablePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: TrackTableCell.identifier, bundle: nil), forCellReuseIdentifier: TrackTableCell.identifier)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableCell.identifier, for: indexPath) as? TrackTableCell else {
            return UITableViewCell()
        }
        return presenter.cellForRowAt(indexPath, cell)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return presenter.canEditRowAt(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplayCellForRowAt(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction] = []
        let actionsCreated = presenter.editActionsForRowAt(editActionsForRowAt)
        for action in actionsCreated {
            let finalAction = UITableViewRowAction(style: .normal, title: action.title) { [weak self] a, i in
                guard let `self` = self else { return }
                self.setEditing(false, animated: true)
                action.action(i)
            }
            finalAction.backgroundColor = UIColor(rgba: action.color)
            actions.append(finalAction)
        }
        return actions
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectRowAt(indexPath)
    }
    
}
