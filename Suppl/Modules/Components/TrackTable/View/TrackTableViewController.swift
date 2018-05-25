import Foundation
import UIKit

final class TrackTableViewController: UITableViewController, TrackTableViewControllerProtocol {
    
    var presenter: TrackTablePresenterProtocolView!
    
    private class UITableViewWithReload: UITableView {
        weak var myController: TrackTableViewController!
        override func reloadData() {
            myController.presenter.updateTracks()
            super.reloadData()
        }
    }
    
    private class TrackTablePlaceholderCell: UITableViewCell {
        static let identifier = String(describing: TrackTablePlaceholderCell.self)
        weak var myController: TrackTableViewController!
        let cellModuleNameId: String
        private let trackInfoController: UIViewController
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            (cellModuleNameId, trackInfoController) = TrackInfoRouter.setup()
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            ViewIncludeTemplate.inside(child: trackInfoController.view, parent: contentView)
            layer.cornerRadius = 5
            clipsToBounds = true
            selectionStyle = .none
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override func prepareForReuse() {
            super.prepareForReuse()
            myController.presenter.resetCell(name: cellModuleNameId)
        }
    }
    
    func relaodData() {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let costomTable = UITableViewWithReload()
        costomTable.myController = self
        tableView = costomTable
        tableView.register(TrackTablePlaceholderCell.self, forCellReuseIdentifier: TrackTablePlaceholderCell.identifier)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        presenter.load()
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        presenter.moveTrack(fromPath: sourceIndexPath, toPath: destinationIndexPath)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return presenter.canMoveTrack(fromPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackTablePlaceholderCell.identifier, for: indexPath) as! TrackTablePlaceholderCell
        if cell.myController == nil {
            cell.myController = self
        }
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
        guard let actionsCreated = presenter.createRowActions(indexPath: editActionsForRowAt) else { return nil }
        var actions: [UITableViewRowAction] = []
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.5;
    }
    
}
