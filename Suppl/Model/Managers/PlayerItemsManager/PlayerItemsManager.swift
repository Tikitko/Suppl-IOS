import Foundation
import AVFoundation

final class PlayerItemsManager {
    
    static public let shared = PlayerItemsManager()
    private init() {
        tracksCacheDirPath = RemoteDataManager.shared.baseCacheDirPath.appendingPathComponent("tracks")
    }
    
    public enum ItemStatus {
        case downloading
        case inQueue
        case exist
        case notExist
    }
    
    public enum ItemStatusWorking {
        case savedReceived
        case errorReceived
        case downloading
        case addedToQueue
        case cancel
        case removed
    }
    
    private struct NamedItem {
        let name: String
        let item: CachingPlayerItem
        var lastLoadPercentages: Int? = nil
        private let delegates: NSMapTable<NSString, AnyObject>
        
        init(name: String, item: CachingPlayerItem, delegates: NSMapTable<NSString, AnyObject>?) {
            self.name = name
            self.item = item
            self.delegates = delegates ?? NSMapTable<NSString, AnyObject>(keyOptions: .strongMemory, valueOptions: .weakMemory)
        }
        
        public func setListener(_ name: String, delegate: PlayerItemDelegate) {
            delegates.setObject(delegate, forKey: name as NSString)
        }
        
        public func removeListener(_ name: String) {
            delegates.removeObject(forKey: name as NSString)
        }
        
        public func getListener(_ name: String) -> PlayerItemDelegate? {
            return delegates.object(forKey: name as NSString) as? PlayerItemDelegate
        }
        
        public func sayToListeners(_ callback: (PlayerItemDelegate) -> Void) {
            for obj in delegates.objectEnumerator() ?? NSEnumerator() {
                guard let delegate = obj as? PlayerItemDelegate else { continue }
                callback(delegate)
            }
        }
        
        public func removeAllListeners() {
            delegates.removeAllObjects()
        }
        
        public func getAllListeners() -> NSMapTable<NSString, AnyObject> {
            return delegates
        }
    }
    
    private let itemMimeType = "audio/mpeg"
    private let itemFileExtension = "mp3"
    
    private var tracksCacheDirPath: URL
    private var downloadQueueItems: [NamedItem] = []
    private var waitingDelegates: [String: NSMapTable<NSString, AnyObject>] = [:]
    private weak var nowDownloading: CachingPlayerItem? = nil
    
    private func saveFileInCacheDir(data: Data, name: String) -> Bool {
        return RemoteDataManager.saveFile(data: data, name: name, path: tracksCacheDirPath)
    }
    
    public func setListener(itemName: String, listenerName: String, delegate: PlayerItemDelegate) {
        if let index = downloadQueueItems.index(where: { $0.name == itemName }) {
            downloadQueueItems[index].setListener(listenerName, delegate: delegate)
        } else {
            if waitingDelegates.index(forKey: itemName) == nil {
                waitingDelegates[itemName] = NSMapTable<NSString, AnyObject>(keyOptions: .strongMemory, valueOptions: .weakMemory)
            }
            waitingDelegates[itemName]?.setObject(delegate, forKey: listenerName as NSString)
        }
    }
    
    public func removeListener(itemName: String, listenerName: String) {
        if let index = downloadQueueItems.index(where: { $0.name == itemName }) {
            downloadQueueItems[index].removeListener(listenerName)
        }
        if waitingDelegates.index(forKey: itemName) != nil {
            waitingDelegates[itemName]?.removeObject(forKey: listenerName as NSString)
            if waitingDelegates[itemName]?.count == 0 {
                waitingDelegates.removeValue(forKey: itemName)
            }
        }
    }
    
    public func addItem(_ name: String, _ url: URL) -> Bool {
        if downloadQueueItems.contains(where: { $0.name == name }),
            FileManager.default.fileExists(atPath: tracksCacheDirPath.appendingPathComponent(name).path),
            url.pathExtension != itemFileExtension { return false }
        let item = CachingPlayerItem(url: url)
        item.delegate = self
        var delegates: NSMapTable<NSString, AnyObject>? = nil
        if waitingDelegates.index(forKey: name) != nil {
            delegates = waitingDelegates[name]
            waitingDelegates.removeValue(forKey: name)
        }
        downloadQueueItems.append(NamedItem(name: name, item: item, delegates: delegates))
        for obj in delegates?.objectEnumerator() ?? NSEnumerator() {
            guard let delegate = obj as? PlayerItemDelegate else { continue }
            delegate.itemStatusChanged(name, .addedToQueue)
        }
        nextDownload()
        return true
    }
    
    public func addItem(_ name: String, completion: @escaping (Bool) -> Void) {
        guard let keys = AuthManager.shared.getAuthKeys() else {
            completion(false)
            return
        }
        APIManager.shared.audio.get(keys: keys, ids: name) { [weak self] error, data in
            if let `self` = self,
               let list = data?.list,
               list.count > 0,
               let trackURL = URL(string: list[0].track ?? "")
            { completion(self.addItem(name, trackURL)) }
            else { completion(false) }
        }
    }

    public func removeActiveItem(_ name: String) -> Bool {
        guard let index = downloadQueueItems.index(where: { $0.name == name }) else { return false }
        downloadQueueItems[index].sayToListeners({ $0.itemStatusChanged(name, .cancel) })
        waitingDelegates[name] = downloadQueueItems[index].getAllListeners()
        downloadQueueItems[index].item.delegate = nil
        let item = downloadQueueItems[index].item
        downloadQueueItems.remove(at: index)
        defer {
            if nowDownloading == item {
                nowDownloading = nil
                nextDownload()
            }
        }
        return true
    }
    
    public func removeSavedItem(_ name: String) -> Bool {
        let forRemove: URL = tracksCacheDirPath.appendingPathComponent(name)
        do {
            try FileManager.default.removeItem(atPath: forRemove.path)
            if waitingDelegates.index(forKey: name) != nil {
                for obj in waitingDelegates[name]?.objectEnumerator() ?? NSEnumerator() {
                    guard let delegate = obj as? PlayerItemDelegate else { continue }
                    delegate.itemStatusChanged(name, .removed)
                }
            }
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
    
    private func itemIsLoading(_ name: String) -> Bool {
        return downloadQueueItems.contains(where: { $0.name == name })
    }
    
    private func itemIsSaved(_ name: String) -> Bool {
        return ((try? FileManager.default.contentsOfDirectory(atPath: tracksCacheDirPath.path)) ?? []).contains(name)
    }
    
    public func getItemStatus(_ name: String) -> ItemStatus {
        if itemIsLoading(name) {
            let index = downloadQueueItems.index(where: { $0.name == name })!
            return downloadQueueItems[index].item == nowDownloading ? .downloading : .inQueue
        }
        if itemIsSaved(name) {
            return .exist
        }
        return .notExist
    }
    
    public func getItemLastLoadPercentages(_ name: String) -> Int? {
        if let index = downloadQueueItems.index(where: { $0.name == name }) {
            return downloadQueueItems[index].lastLoadPercentages
        }
        return nil
    }
    
    public func resetAllCachedItems() {
        try? FileManager.default.removeItem(atPath: tracksCacheDirPath.path)
    }
    
    public func removeDownloadableItems() {
        downloadQueueItems = []
        nowDownloading = nil
    }
    
    private func nextDownload() {
        if let item = downloadQueueItems.first, nowDownloading == nil {
            nowDownloading = item.item
            item.item.download()
            item.sayToListeners({ $0.itemStatusChanged(item.name, .downloading) })
        }
    }
    
    private func endDownload(forItem playerItem: CachingPlayerItem, data: Data?) {
        if let index = downloadQueueItems.index(where: { $0.item == playerItem }) {
            playerItem.delegate = nil
            let item = downloadQueueItems[index]
            let result = data != nil && saveFileInCacheDir(data: data!, name: item.name)
            item.sayToListeners({ $0.itemStatusChanged(item.name, result ? .savedReceived : .errorReceived) })
            waitingDelegates[item.name] = downloadQueueItems[index].getAllListeners()
            downloadQueueItems.remove(at: index)
            nowDownloading = nil
        }
        nextDownload()
    }
    
    private func changedProgress(forItem playerItem: CachingPlayerItem, didDownloadBytesSoFar bytesDownloaded: Int, outOf bytesExpected: Int) {
        if let index = downloadQueueItems.index(where: { $0.item == playerItem }) {
            let percentage = (bytesDownloaded * 100) / bytesExpected
            downloadQueueItems[index].lastLoadPercentages = percentage
            downloadQueueItems[index].sayToListeners({ $0.itemDownloadingProgressChanged(downloadQueueItems[index].name, percentage) })
        }
    }
    
}

extension PlayerItemsManager: CachingPlayerItemDelegate {
    
    func playerItem(_ playerItem: CachingPlayerItem, didFinishDownloadingData data: Data) {
        DispatchQueue.main.sync { [weak self] in
            self?.endDownload(forItem: playerItem, data: data)
        }
    }

    func playerItem(_ playerItem: CachingPlayerItem, didDownloadBytesSoFar bytesDownloaded: Int, outOf bytesExpected: Int) {
        DispatchQueue.main.sync { [weak self] in
            self?.changedProgress(forItem: playerItem, didDownloadBytesSoFar: bytesDownloaded, outOf: bytesExpected)
        }
    }

    func playerItem(_ playerItem: CachingPlayerItem, downloadingFailedWith error: Error) {
        DispatchQueue.main.sync { [weak self] in
            self?.endDownload(forItem: playerItem, data: nil)
        }
    }
    
}
