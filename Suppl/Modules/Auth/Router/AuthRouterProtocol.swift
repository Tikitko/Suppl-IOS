import Foundation
import UIKit

protocol AuthRouterProtocol: RouterProtocol {
    func goToRootTabBar()
    static func setup(noAuth noAuthOnShow: Bool) -> UIViewController
}
