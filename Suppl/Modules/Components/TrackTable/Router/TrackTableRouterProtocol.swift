import Foundation
import UIKit

protocol TrackTableRouterProtocol: class {
    func createCell(isSmall: Bool) -> (moduleNameId: String, controller: UIViewController)
    func showToastOnTop(title: String, body: String, duration: Double)
}
