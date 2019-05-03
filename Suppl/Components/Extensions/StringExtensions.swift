import Foundation

extension String {
    
    var plist: [String: Any]? {
        guard let pathStr = Bundle.main.path(forResource: self, ofType: "plist"),
            let data = NSData(contentsOfFile: pathStr),
            let anyList = try? PropertyListSerialization.propertyList(from: data as Data, options: [], format: nil),
            let list = anyList as? [String: Any]
            else { return nil }
        return list
    }
    
    var localizeKey: String {
        return LocalesManager.shared.localized(self)
    }
    
}
