import Foundation
import UIKit

protocol TrackTableRouterProtocol: class, BaseRouterProtocol {
    func showToastOnTop(title: String, body: String, duration: Double)
}
