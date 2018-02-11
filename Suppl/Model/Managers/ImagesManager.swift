import Foundation
import UIKit

class ImagesManager {
    
    private static var cache = NSCache<NSString, UIImage>()
    
    public static func getImage(link: String, noCache: Bool = false, callbackImage: @escaping (UIImage) -> ()) {
        guard let load = SettingsManager.loadImages, load else { return }
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
                let data = data,
                let image = UIImage(data: data)
                else { return }
            cache.setObject(image, forKey: nsLink)
            callbackImage(image)
        }
    }
    
    public static func clearCache() {
        cache.removeAllObjects()
    }
    
    public static func removeFromCache(link: String) {
        cache.removeObject(forKey: link as NSString)
    }
}
