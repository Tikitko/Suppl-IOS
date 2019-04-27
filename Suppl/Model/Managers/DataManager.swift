import Foundation
import UIKit

final class DataManager {
    
    private struct Constants {
        static let cacheDirName = "SupplCache"
        static let thumbsDirName = "thumbs"
        static let fullJPGType = ".jpg"
    }
    
    static public let shared = DataManager()
    private init() {
        thumbsCacheDirPath = baseCacheDirPath.appendingPathComponent(Constants.thumbsDirName)
    }
    
    public static var documentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    private var cache = NSCache<NSString, NSData>()
    private let session = CommonSession()
    public let baseCacheDirPath = DataManager.documentsDirectory.appendingPathComponent(Constants.cacheDirName)
    private let thumbsCacheDirPath: URL
    
    public func getData(link: String, noCache: Bool = false, inMainQueue: Bool = true, callbackData: @escaping (Data) -> ()) {
        if !noCache, let cachedVersion = getFromCache(link) {
            callbackData(cachedVersion)
            return
        }
        session.request(url: link, inMainQueue: inMainQueue) { [weak self] error, response, data in
            guard let self = self, let data = data else { return }
            self.setToCache(link, data: data)
            callbackData(data)
        }
    }
    
    private func getFromCache(_ key: String) -> Data? {
        return cache.object(forKey: key as NSString) as Data?
    }
    
    private func setToCache(_ key: String, data: Data) {
        cache.setObject(data as NSData, forKey: key as NSString)
    }
    
    public func getCachedImage(link: String, imagesLifetime: Int = 6, callbackImage: @escaping (UIImage) -> ()) {
        getCachedImageAsData(link: link, imagesLifetime: imagesLifetime, backInMain: false) { data in
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async { callbackImage(image) }
        }
    }
    
    public func getCachedImageAsData(link: String, imagesLifetime: Int = 6, backInMain: Bool = true, callbackImageData: @escaping (Data) -> ()) {
        DispatchQueue.global(qos: .utility).async() { [weak self] in
            guard let self = self else { return }
            let callback: (_ data: Data) -> Void = { data in
                backInMain ? DispatchQueue.main.async { callbackImageData(data) } : callbackImageData(data)
            }
            if let imageDataCache = self.getFromCache(link), let _ = UIImage(data: imageDataCache) {
                callback(imageDataCache)
                return
            }
            guard let imageName = URL(string: link)?.path else { return }
            let filename = self.thumbsCacheDirPath.appendingPathComponent(imageName)
            if FileManager.default.fileExists(atPath: filename.path),
               let imageDataDisk = try? Data(contentsOf: filename),
               let _ = UIImage(data: imageDataDisk)
            {
                var imageAlive = false
                if let dateAny = try? FileManager.default.attributesOfItem(atPath: filename.path)[.modificationDate],
                    let editDate = dateAny as? Date,
                    let hours = Calendar.current.dateComponents([.hour], from: editDate, to: Date()).hour,
                    hours < imagesLifetime
                {
                    imageAlive = true
                } else {
                    imageAlive = OfflineModeManager.shared.offlineMode
                }
                if imageAlive {
                    self.setToCache(link, data: imageDataDisk)
                    callback(imageDataDisk)
                    return
                } else {
                    try? FileManager.default.removeItem(atPath: filename.path)
                }
            }
            if OfflineModeManager.shared.offlineMode { return }
            self.getData(link: link, noCache: true, inMainQueue: false) { data in
                guard let _ = UIImage(data: data) else { return }
                try? FileManager.default.createDirectory(at: filename.deletingLastPathComponent(), withIntermediateDirectories: true)
                try? data.write(to: filename, options: [.atomic])
                callback(data)
            }
        }
    }
    
    public func resetAllCachedImages() {
        try? FileManager.default.removeItem(atPath: thumbsCacheDirPath.path)
        clearCache()
    }
    
    public func resetOldCachedImages(imagesLifetime: Int = 6) {
        if OfflineModeManager.shared.offlineMode { return }
        let imagesPaths = searchJPGImages(pathURL: thumbsCacheDirPath)
        for imagePath in imagesPaths {
            if FileManager.default.fileExists(atPath: imagePath),
                let dateAny = try? FileManager.default.attributesOfItem(atPath: imagePath)[.modificationDate],
                let editDate = dateAny as? Date,
                let hours = Calendar.current.dateComponents([.hour], from: editDate, to: Date()).hour,
                hours < imagesLifetime
            { return }
            try? FileManager.default.removeItem(atPath: imagePath)
        }
    }
    
    private func searchJPGImages(pathURL: URL) -> [String] {
        var imageURLs: [String] = []
        let fileManager = FileManager.default
        let keys: [URLResourceKey] = [.isDirectoryKey, .localizedNameKey]
        let options: FileManager.DirectoryEnumerationOptions = [.skipsPackageDescendants, .skipsSubdirectoryDescendants, .skipsHiddenFiles]
        let enumerator = fileManager.enumerator(
            at: pathURL,
            includingPropertiesForKeys: keys,
            options: options,
            errorHandler: { url, error -> Bool in true }
        )
        while let file = enumerator?.nextObject() {
            let filePathURL = file as! URL
            if filePathURL.path.hasSuffix(Constants.fullJPGType) {
                imageURLs.append(filePathURL.path)
            } else {
                imageURLs += searchJPGImages(pathURL: filePathURL)
            }
        }
        return imageURLs
    }
 
    public func clearCache() {
        cache.removeAllObjects()
    }
    
    public func removeFromCache(_ key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    public static func directoryExistsAtPath(_ path: URL) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path.path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
    public static func saveFile(data: Data, name: String, path: URL) -> Bool {
        do {
            if !DataManager.directoryExistsAtPath(path) {
                try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)
            }
            try data.write(to: path.appendingPathComponent(name), options: [.atomic])
            return true
        } catch {
            return false
        }
    }
    
}
