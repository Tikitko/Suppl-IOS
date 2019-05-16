import Foundation
import UIKit

protocol TrackTableRouterProtocol: class {
    func createCell(isSmall: Bool) -> (moduleId: String, viewController: UIViewController)
    func showToastOnTop(title: String, body: String, duration: Double)
}
