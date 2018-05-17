import Foundation
import UIKit

final class TrackTableViewController: UITableViewController, TrackTableViewControllerProtocol {
    
    var presenter: TrackTablePresenterProtocol!
    
    private class UITableViewWithReload: UITableView {
        weak var myController: TrackTableViewController?
        override func reloadData() {
            myController?.inReloadData()
            super.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let costomTable = UITableViewWithReload()
        costomTable.myController = self
        tableView = costomTable
        
        tableView.register(UINib(nibName: TrackTableCell.identifier, bundle: nil), forCellReuseIdentifier: TrackTableCell.identifier)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    func inReloadData() {
        presenter.updateTracks()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableCell.identifier, for: indexPath) as! TrackTableCell
        let infoCallback: (AudioData) -> Void = { track in
            cell.configure(title: track.title, performer: track.performer, duration: track.duration)
        }
        let imageCallback: (NSData) -> Void = { imageData in
            guard cell.baseImage else { return }
            cell.setImage(imageData: imageData)
        }
        presenter.getTrackDataByIndex(indexPath.row, infoCallback: infoCallback, imageCallback: imageCallback)
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
    
}
