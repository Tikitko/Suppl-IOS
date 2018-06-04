import Foundation
import UIKit

protocol AuthRouterProtocol: class, BaseRouterProtocol {
    func goToRootTabBar()
    static func setup(noAuth noAuthOnShow: Bool) -> UIViewController
}
