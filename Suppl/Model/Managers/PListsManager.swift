import Foundation

final class PListsManager {
    
    static public let s = PListsManager()
    private init() {}
    
    func loadPList(_ name: String) -> [String:Any]? {
        guard let pathStr = Bundle.main.path(forResource: name, ofType: "plist"), let data = NSData(contentsOfFile: pathStr) else { return nil }
        let dataPList = try? PropertyListSerialization.propertyList(from: data as Data, options: [], format: nil)
        return dataPList as? [String:Any]
    }
    
}
