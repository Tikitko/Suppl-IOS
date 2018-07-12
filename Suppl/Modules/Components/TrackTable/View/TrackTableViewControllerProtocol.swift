import Foundation

protocol TrackTableViewControllerProtocol: class {
    var smallCell: Bool! { get set }
    func reloadData()
}
