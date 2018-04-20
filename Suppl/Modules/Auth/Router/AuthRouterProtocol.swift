import Foundation
import UIKit

protocol AuthRouterProtocol: class {
    func goToRootTabBar()
    static func setup(noAuth noAuthOnShow: Bool) -> UIViewController
}
