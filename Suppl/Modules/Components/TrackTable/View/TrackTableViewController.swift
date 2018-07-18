import Foundation
import UIKit

final class TrackTableViewController: UITableViewController, TrackTableViewControllerProtocol {
    
    var presenter: TrackTablePresenterProtocolView!
    
    var smallCell: Bool!
    var startContentOffset: CGFloat?
    
    override var isEditing: Bool {
        set(value) {
            if !presenter.canEdit { return }
            super.isEditing = value
        }
        get {
            return super.isEditing
        }
    }
    
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
        private(set) var cellModuleNameId: String?
        private var trackInfoController: UIViewController?
        private(set) var small: Bool?
        func initInfoController(small: Bool = false) {
            trackInfoController?.view.removeFromSuperview()
            self.small = small
            let trackInfoBox = myController.presenter.getCell(small: small)
            cellModuleNameId = trackInfoBox.moduleNameId
            trackInfoController = trackInfoBox.controller
            trackInfoController!.view.frame = contentView.bounds
            trackInfoController!.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            contentView.addSubview(trackInfoController!.view)
            layer.cornerRadius = 5
            clipsToBounds = true
        }
        override func prepareForReuse() {
            if let cellModuleNameId = cellModuleNameId {
                myController.presenter.resetCell(name: cellModuleNameId)
            }
            super.prepareForReuse()
        }
        override func setSelected(_ selected: Bool, animated: Bool) {
            enableBackground(selected, duration: animated ? 0.4 : nil)
        }
        override func setHighlighted(_ highlighted: Bool, animated: Bool) {
            enableBackground(highlighted, duration: animated ? 0.05 : nil)
        }
        private func enableBackground(_ isOn: Bool, duration: TimeInterval? = nil) {
            let changes = { self.backgroundColor = isOn ? UIColor(white: 0.9, alpha: 1.0) : nil }
            duration != nil ? UIView.animate(withDuration: duration!, animations: changes) : changes()
        }
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    /*
    func loadMoreCells(inBottom value: Bool, _ count: Int = 3) {
        guard let lastCell = value ? tableView.visibleCells.last : tableView.visibleCells.first, let lastCellIndex = tableView.indexPath(for: lastCell) else { return }
        let rowsCount = tableView(tableView, numberOfRowsInSection: 0)
        let to = value ? 1 : -1
        for index in stride(from: lastCellIndex.row, to: lastCellIndex.row + (count * to), by: to) {
            if index >= rowsCount || index < 0 { break }
            let _ = tableView(tableView, cellForRowAt: IndexPath(row: index, section: 0))
        }
    }
    */

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.requestCellSetting()
        let costomTable = UITableViewWithReload()
        costomTable.myController = self
        tableView = costomTable
        tableView.register(TrackTablePlaceholderCell.self, forCellReuseIdentifier: TrackTablePlaceholderCell.identifier)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        presenter.load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.requestCellSetting()
        presenter.reloadWhenChangingSettings()
    }
    
    /*
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return presenter.rowEditType(indexPath: indexPath)
    }
    */
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        presenter.moveTrack(fromPath: sourceIndexPath, toPath: destinationIndexPath)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return presenter.canMoveTrack(fromPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackTablePlaceholderCell.identifier, for: indexPath) as! TrackTablePlaceholderCell
        if cell.myController == nil {
            cell.myController = self
        }
        if cell.cellModuleNameId == nil || cell.small != smallCell {
            cell.initInfoController(small: smallCell)
        }
        presenter.updateCellInfo(trackIndex: indexPath.row, name: cell.cellModuleNameId!)
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
            let finalAction = UITableViewRowAction(style: .normal, title: action.title) { [weak self] _, i in
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
        return smallCell ? 50.5 : 90.5
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let range: CGFloat = 100
        guard let startContentOffset = startContentOffset,
              scrollView.contentSize.height + range > scrollView.frame.height,
              scrollView.contentOffset.y + scrollView.frame.height < scrollView.contentSize.height
            else { return }
        if startContentOffset > scrollView.contentOffset.y + range || scrollView.contentOffset.y <= 0  {
            presenter.sayThatZonePassed(toTop: true)
            scrollViewWillBeginDragging(scrollView)
        }
        if startContentOffset < scrollView.contentOffset.y - range {
            presenter.sayThatZonePassed(toTop: false)
            scrollViewWillBeginDragging(scrollView)
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startContentOffset = scrollView.contentOffset.y
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startContentOffset = nil
    }
    
}
