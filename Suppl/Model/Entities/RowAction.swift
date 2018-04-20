import Foundation

struct RowAction {
    let color: String
    let title: String
    let action: (_ indexPath: IndexPath) -> Void
}
