import Foundation

protocol TrackTableViewControllerProtocol: class {
    func setSmallCells(_ value: Bool, forAlways: Bool)
    var allowDownloadButton: Bool { get set }
    var useLightStyle: Bool { get set }
    func followToIndex(_ index: Int, inVisibilityZone: Bool)
    func reloadData()
}
