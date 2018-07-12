import Foundation

final class PListsManager {
    
    static public let shared = PListsManager()
    private init() {}
    
    func loadPList(_ name: String) -> [String:Any]? {
        guard let pathStr = Bundle.main.path(forResource: name, ofType: "plist"), let data = NSData(contentsOfFile: pathStr) else { return nil }
        return (try? PropertyListSerialization.propertyList(from: data as Data, options: [], format: nil)) as? [String:Any]
    }
    
}
