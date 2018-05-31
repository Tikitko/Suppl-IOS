import Foundation
import UIKit

final class RemoteDataManager {
    
    static public let s = RemoteDataManager()
    private init() {}
    
    private var cache = NSCache<NSString, NSData>()
    private let session = CommonRequest()
    private let cacheDirPath = RemoteDataManager.getDocumentsDirectory().appendingPathComponent(AppStaticData.cacheDir).appendingPathComponent("thumbs")
    
    public func getData(link: String, noCache: Bool = false, callbackData: @escaping (NSData) -> ()) {
        let nsLink = link as NSString
        if let cachedVersion = cache.object(forKey: nsLink), !noCache {
            callbackData(cachedVersion)
            return
        }
        session.request(url: link) { [weak self] error, response, data in
            guard let `self` = self, let data = data else { return }
            let nsData = data as NSData
            self.cache.setObject(nsData, forKey: nsLink)
            callbackData(nsData)
        }
    }
    
    public func getCachedImage(link: String, imagesLifetime: Int = 6, callbackImage: @escaping (UIImage) -> ()) {
        guard let imageName = URL(string: link)?.path else { return }
        let filename = cacheDirPath.appendingPathComponent(imageName)
        if FileManager.default.fileExists(atPath: filename.path), let image = UIImage(contentsOfFile: filename.path) {
            var imageAlive = false
            if let dateAny = try? FileManager.default.attributesOfItem(atPath: filename.path)[FileAttributeKey.modificationDate],
                let editDate = dateAny as? Date,
                let hours = Calendar.current.dateComponents([.hour], from: editDate, to: Date()).hour,
                hours < imagesLifetime
            {
                imageAlive = true
            } else {
                imageAlive = OfflineModeManager.s.offlineMode ? true : false
            }
            if imageAlive {
                callbackImage(image)
                return
            } else {
                try? FileManager.default.removeItem(atPath: filename.path)
            }
        }
        if OfflineModeManager.s.offlineMode { return }
        getData(link: link, noCache: true) { data in
            guard let image = UIImage(data: data as Data), let data = UIImageJPEGRepresentation(image, 1.0) else { return }
            try? FileManager.default.createDirectory(at: filename.deletingLastPathComponent(), withIntermediateDirectories: true)
            try? data.write(to: filename, options: [.atomic])
            callbackImage(image)
        }
    }
    
    public func getCachedImageAsData(link: String, imagesLifetime: Int = 6, callbackImageData: @escaping (Data) -> ()) {
        getCachedImage(link: link, imagesLifetime: imagesLifetime) {
            guard let imageData = UIImageJPEGRepresentation($0, 1.0) else { return }
            callbackImageData(imageData)
        }
    }
    
    public func resetAllCachedImages() {
        if OfflineModeManager.s.offlineMode { return }
        try? FileManager.default.removeItem(atPath: cacheDirPath.path)
    }
    
    public func resetOldCachedImages(imagesLifetime: Int = 6) {
        if OfflineModeManager.s.offlineMode { return }
        let imagesPaths = searchJPGImages(pathURL: cacheDirPath)
        for imagePath in imagesPaths {
            if FileManager.default.fileExists(atPath: imagePath),
                let dateAny = try? FileManager.default.attributesOfItem(atPath: imagePath)[FileAttributeKey.modificationDate],
                let editDate = dateAny as? Date,
                let hours = Calendar.current.dateComponents([.hour], from: editDate, to: Date()).hour,
                hours < imagesLifetime { return }
            try? FileManager.default.removeItem(atPath: imagePath)
        }
    }
    
    private func searchJPGImages(pathURL: URL) -> [String] {
        var imageURLs = [String]()
        let fileManager = FileManager.default
        let keys = [URLResourceKey.isDirectoryKey, URLResourceKey.localizedNameKey]
        let options: FileManager.DirectoryEnumerationOptions = [.skipsPackageDescendants, .skipsSubdirectoryDescendants, .skipsHiddenFiles]
        
        let enumerator = fileManager.enumerator(
            at: pathURL,
            includingPropertiesForKeys: keys,
            options: options,
            errorHandler: {(url, error) -> Bool in
                return true
        })
        
        if enumerator != nil {
            while let file = enumerator!.nextObject() {
                let filePathURL = file as! URL
                if filePathURL.path.hasSuffix(".jpg"){
                    imageURLs.append(filePathURL.path)
                } else {
                    imageURLs += searchJPGImages(pathURL: filePathURL)
                }
            }
        }
        
        return imageURLs
    }
    
    private static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
 
    public func clearCache() {
        cache.removeAllObjects()
    }
    
    public func removeFromCache(link: String) {
        cache.removeObject(forKey: link as NSString)
    }
}
