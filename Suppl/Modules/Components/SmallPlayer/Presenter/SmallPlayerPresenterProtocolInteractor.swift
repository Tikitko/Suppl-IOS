import Foundation
import UIKit

protocol SmallPlayerPresenterProtocolInteractor: class {
    var moduleNameId: String { get }
    var playlist: [AudioData] { get set }
    func inStart()
}
