import Foundation
import UIKit

final class TrackTableViewController: UITableViewController, TrackTableViewControllerProtocol {
    
    var presenter: TrackTablePresenterProtocol!
    
    private class UITableViewWithReload: UITableView {
        weak var myController: TrackTableViewController!
        override func reloadData() {
            myController.presenter.updateTracks()
            super.reloadData()
        }
    }
    
    private class TrackTablePlaceholderCell: UITableViewCell {
        static let identifier = String(describing: TrackTablePlaceholderCell.self)
        private(set) var cellModuleNameId: String!
        private var cell: UITableViewCell!
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            baseSetting()
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            baseSetting()
        }
        private func baseSetting() {
            var cellModuleNameId = String(arc4random_uniform(1000000001))
            cell = TrackTableCell.init(cellModuleNameId: &cellModuleNameId)
            self.cellModuleNameId = cellModuleNameId
            ViewIncludeTemplate.inside(child: cell!, parent: self)
        }
        override func prepareForReuse() {
            super.prepareForReuse()
            cell.prepareForReuse()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let costomTable = UITableViewWithReload()
        costomTable.myController = self
        tableView = costomTable
        tableView.register(TrackTablePlaceholderCell.self, forCellReuseIdentifier: TrackTablePlaceholderCell.identifier)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackTablePlaceholderCell.identifier, for: indexPath) as! TrackTablePlaceholderCell
        presenter.updateCellInfo(trackIndex: indexPath.row, name: cell.cellModuleNameId)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return presenter.rowEditStatus(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplayCellForRowAt(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        var actions: [UITableViewRowAction] = []
        var actionsCreated: [RowAction] = []
        presenter.createRowActions(indexPath: editActionsForRowAt, actions: &actionsCreated)
        for action in actionsCreated {
            let finalAction = UITableViewRowAction(style: .normal, title: action.title) { [weak self] a, i in
                self?.setEditing(false, animated: true)
                action.action(i)
            }
            finalAction.backgroundColor = UIColor(rgba: action.color)
            actions.append(finalAction)
        }
        return actions
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.openPlayer(trackIndex: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90.5;
    }
    
}
