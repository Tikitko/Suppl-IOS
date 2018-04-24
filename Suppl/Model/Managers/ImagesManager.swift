import Foundation

class ImagesManager {
    
    private static var cache = NSCache<NSString, NSData>()
    
    public static func getImage(link: String, noCache: Bool = false, callbackImage: @escaping (NSData) -> ()) {
        guard SettingsManager.loadImages! else { return }
        let nsLink = link as NSString
        if let cachedVersion = cache.object(forKey: nsLink) {
            if noCache {
                cache.removeObject(forKey: nsLink)
            } else {
                callbackImage(cachedVersion)
                return
            }
        }
        APIManager.API.request(url: link, inMain: true) { error, response, data in
            guard let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data
                else { return }
            let nsData = data as NSData
            cache.setObject(nsData, forKey: nsLink)
            callbackImage(nsData)
        }
    }
    
    public static func clearCache() {
        cache.removeAllObjects()
    }
    
    public static func removeFromCache(link: String) {
        cache.removeObject(forKey: link as NSString)
    }
}
