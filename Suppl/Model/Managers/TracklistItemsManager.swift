import Foundation

final class TracklistItemsManager {
    
    static public let s = TracklistItemsManager()
    private init() {}
    
    /*
    private let cacheDirPath = RemoteDataManager.getDocumentsDirectory().appendingPathComponent(AppStaticData.cacheDir).appendingPathComponent("tracks")
    
    var items: [CachingPlayerItem] = []
    
    private func saveFile(data: Data, name: String) -> Bool {
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else { return false }
        do {
            try data.write(to: directory.appendingPathComponent(name)!)
            return true
        } catch {
            return false
        }
    }
     */
    
}
