import Foundation
import AVFoundation

protocol PlayerItemDelegate: class {
    func itemStatusChanged(_ itemName: String,  _ status: PlayerItemsManager.ItemStatusWorking)
    func itemDownloadingProgressChanged(_ itemName: String, _ percentDownloaded: Int)
}

extension PlayerItemDelegate {
    func itemStatusChanged(_ itemName: String, _ status: PlayerItemsManager.ItemStatusWorking) {}
    func itemDownloadingProgressChanged(_ itemName: String, _ percentDownloaded: Int) {}
}
