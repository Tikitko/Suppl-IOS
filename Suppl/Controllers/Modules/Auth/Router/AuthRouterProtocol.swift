import Foundation
import UIKit

protocol AuthRouterProtocol {
    func goToRootTabBar()
    static func setupInWindow() -> UIWindow
    static func setup(noAuth noAuthOnShow: Bool) -> UIViewController
}
