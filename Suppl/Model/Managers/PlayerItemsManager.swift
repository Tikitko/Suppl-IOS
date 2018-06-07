import Foundation
import AVFoundation

final class PlayerItemsManager {
    
    static public let s = PlayerItemsManager()
    private init() {
        tracksCacheDirPath = RemoteDataManager.s.baseCacheDirPath.appendingPathComponent("tracks")
    }
    
    private struct NamedItem {
        let name: String
        let item: CachingPlayerItem
    }
    
    private let itemMimeType = "audio/mpeg"
    private let itemFileExtension = "mp3"
    
    private var tracksCacheDirPath: URL
    private var downloadQueueItems: [NamedItem] = []
    private weak var nowDownloading: CachingPlayerItem? = nil
    
    private func saveFileInCacheDir(data: Data, name: String) -> Bool {
        return RemoteDataManager.saveFile(data: data, name: name, path: tracksCacheDirPath)
    }
    
    public func addItem(_ name: String, _ url: URL) -> Bool {
        if downloadQueueItems.contains(where: { $0.name == name }),
            FileManager.default.fileExists(atPath: tracksCacheDirPath.appendingPathComponent(name).path),
            url.pathExtension != itemFileExtension { return false }
        let item = CachingPlayerItem(url: url)
        item.delegate = self
        downloadQueueItems.append(NamedItem(name: name, item: item))
        nextDownload()
        return true
    }
    
    private func removeActiveItem(_ name: String) -> Bool {
        guard let index = downloadQueueItems.index(where: { $0.name == name }) else { return false }
        downloadQueueItems[index].item.delegate = nil
        let item = downloadQueueItems[index].item
        downloadQueueItems.remove(at: index)
        defer {
            if nowDownloading == item {
                nextDownload()
            }
        }
        return true
    }
    
    private func removeSavedItem(_ name: String) -> Bool {
        let forRemove: URL = tracksCacheDirPath.appendingPathComponent(name)
        do {
            try FileManager.default.removeItem(atPath: forRemove.path)
            return true
        } catch {
            return false
        }
    }
    
    public func removeItem(_ name: String) -> Bool {
        return removeActiveItem(name) || removeSavedItem(name)
    }

    public func getItem(_ name: String) -> AVPlayerItem? {
        var item: AVPlayerItem? = nil
        if let index = downloadQueueItems.index(where: { $0.name == name }) {
            item = downloadQueueItems[index].item.copy() as? AVPlayerItem
        } else if let data = FileManager.default.contents(atPath: tracksCacheDirPath.appendingPathComponent(name).path) {
            item = CachingPlayerItem(data: data, mimeType: itemMimeType, fileExtension: itemFileExtension) as AVPlayerItem
        }
        return item
    }
    
    public func getExistingItems() -> (inLoad: [String], ready: [String]) {
        var inLoad: [String] = []
        for box in downloadQueueItems {
            inLoad.append(box.name)
        }
        return (inLoad, (try? FileManager.default.contentsOfDirectory(atPath: tracksCacheDirPath.path)) ?? [])
    }
    
    public func resetAllCachedItems() {
        try? FileManager.default.removeItem(atPath: tracksCacheDirPath.path)
    }
    
    public func removeDownloadableItems() {
        downloadQueueItems = []
        nowDownloading = nil
    }
    
    private func nextDownload() {
        nowDownloading = downloadQueueItems.first?.item
        downloadQueueItems.first?.item.download()
    }
    
    private func endDownload(forItem playerItem: CachingPlayerItem, data: Data?) {
        if let index = downloadQueueItems.index(where: { $0.item == playerItem }) {
            playerItem.delegate = nil
            let name = downloadQueueItems[index].name
            downloadQueueItems.remove(at: index)
            if let data = data {
                let _ = saveFileInCacheDir(data: data, name: name)
            }
        }
        nextDownload()
    }
    
}

extension PlayerItemsManager: CachingPlayerItemDelegate {
    
    func playerItem(_ playerItem: CachingPlayerItem, didFinishDownloadingData data: Data) {
        endDownload(forItem: playerItem, data: data)
    }

    func playerItem(_ playerItem: CachingPlayerItem, didDownloadBytesSoFar bytesDownloaded: Int, outOf bytesExpected: Int) {}

    func playerItemReadyToPlay(_ playerItem: CachingPlayerItem) {}

    func playerItemPlaybackStalled(_ playerItem: CachingPlayerItem) {}

    func playerItem(_ playerItem: CachingPlayerItem, downloadingFailedWith error: Error) {
        endDownload(forItem: playerItem, data: nil)
    }
    
}
