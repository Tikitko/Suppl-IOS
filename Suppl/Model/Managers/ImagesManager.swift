import Foundation

final class ImagesManager {
    
    static public let s = ImagesManager()
    private init() {}
    
    private var cache = NSCache<NSString, NSData>()
    private let session = CommonRequest()
    
    public func getImage(link: String, noCache: Bool = false, callbackImage: @escaping (NSData) -> ()) {
        guard SettingsManager.s.loadImages! else { return }
        let nsLink = link as NSString
        if let cachedVersion = cache.object(forKey: nsLink) {
            if noCache {
                cache.removeObject(forKey: nsLink)
            } else {
                callbackImage(cachedVersion)
                return
            }
        }
        session.request(url: link, inMain: true) { [weak self] error, response, data in
            guard let `self` = self else { return }
            guard let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data
                else { return }
            let nsData = data as NSData
            self.cache.setObject(nsData, forKey: nsLink)
            callbackImage(nsData)
        }
    }
    
    public func clearCache() {
        cache.removeAllObjects()
    }
    
    public func removeFromCache(link: String) {
        cache.removeObject(forKey: link as NSString)
    }
}
