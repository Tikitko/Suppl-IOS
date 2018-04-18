import Foundation
import UIKit

protocol PlayerRouterProtocol: class {
    static func setup(tracksIDs: [String], current: Int) -> UIViewController
}
