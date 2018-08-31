import Foundation

final class PListsManager {
    
    static public let shared = PListsManager()
    private init() {}
    
    func loadPList(_ name: String) -> [String: Any]? {
        guard let pathStr = Bundle.main.path(forResource: name, ofType: AppStaticData.Consts.plistType),
              let data = NSData(contentsOfFile: pathStr),
              let anyList = try? PropertyListSerialization.propertyList(from: data as Data, options: [], format: nil),
              let list = anyList as? [String: Any]
            else { return nil }
        return list
    }
    
}
