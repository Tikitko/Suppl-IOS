import Foundation
import UIKit

protocol TrackTableRouterProtocol: RouterProtocol {
    func createCell(small: Bool) -> (moduleNameId: String, controller: UIViewController)
    func showToastOnTop(title: String, body: String, duration: Double)
}
