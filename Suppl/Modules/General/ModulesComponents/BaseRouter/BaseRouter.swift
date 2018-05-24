import Foundation

class BaseRouter {
    
    let moduleNameId: String

    init() {
        moduleNameId = String(describing: "\(NSStringFromClass(type(of: self)))-\(arc4random_uniform(1000000001))")
    }
    
}
