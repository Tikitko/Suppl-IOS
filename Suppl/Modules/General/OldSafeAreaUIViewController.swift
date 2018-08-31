import Foundation
import UIKit

class OldSafeAreaUIViewController: UIViewController {
    
    private var safeAreaFixLoaded = false
    
    private var topSafeAreaMargin: CGFloat?
    private var bottomSafeAreaMargin: CGFloat?
    
    private func fixSafeArea() {
        let tIndex = view.constraints.index(where: { $0.identifier == AppStaticData.Consts.topSafeAreaConstraintIdentifier })
        let bIndex = view.constraints.index(where: { $0.identifier == AppStaticData.Consts.bottomSafeAreaConstraintIdentifier })
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
