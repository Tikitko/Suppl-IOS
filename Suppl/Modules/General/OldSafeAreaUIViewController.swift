import Foundation
import UIKit

class OldSafeAreaUIViewController: UIViewController {
    
    private struct Constants {
        static let topSafeAreaConstraintIdentifier = "topSafeAreaConstraint"
        static let bottomSafeAreaConstraintIdentifier = "bottomSafeAreaConstraint"
    }
    
    private var safeAreaFixLoaded = false
    
    private var topSafeAreaMargin: CGFloat?
    private var bottomSafeAreaMargin: CGFloat?
    
    private func fixSafeArea() {
        let tIndex = view.constraints.firstIndex(where: { $0.identifier == Constants.topSafeAreaConstraintIdentifier })
        let bIndex = view.constraints.firstIndex(where: { $0.identifier == Constants.bottomSafeAreaConstraintIdentifier })
        if !safeAreaFixLoaded {
            safeAreaFixLoaded = true
            if let tIndex = tIndex {
                topSafeAreaMargin = view.constraints[tIndex].constant
            }
            if let bIndex = bIndex {
                bottomSafeAreaMargin = view.constraints[bIndex].constant
            }
        }
        if let tIndex = tIndex, let topSafeAreaMargin = topSafeAreaMargin {
            view.constraints[tIndex].constant = topLayoutGuide.length + topSafeAreaMargin
        }
        if let bIndex = bIndex, let bottomSafeAreaMargin = bottomSafeAreaMargin {
            view.constraints[bIndex].constant = bottomLayoutGuide.length + bottomSafeAreaMargin
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11, *) { return }
        fixSafeArea()
    }
    
}
