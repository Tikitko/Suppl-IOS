import Foundation

final class RemoteDataManager {
    
    static public let s = RemoteDataManager()
    private init() {}
    
    private var cache = NSCache<NSString, NSData>()
    private let session = CommonRequest()
    
    public func getData(link: String, noCache: Bool = false, callbackData: @escaping (NSData) -> ()) {
        let nsLink = link as NSString
        if let cachedVersion = cache.object(forKey: nsLink) {
            if noCache {
                cache.removeObject(forKey: nsLink)
            } else {
                callbackData(cachedVersion)
                return
            }
        }
        session.request(url: link, inMain: true) { [weak self] error, response, data in
            guard let `self` = self, let data = data else { return }
            let nsData = data as NSData
            self.cache.setObject(nsData, forKey: nsLink)
            callbackData(nsData)
        }
    }
    
    public func clearCache() {
        cache.removeAllObjects()
    }
    
    public func removeFromCache(link: String) {
        cache.removeObject(forKey: link as NSString)
    }
}
