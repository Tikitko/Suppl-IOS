import Foundation

enum LocaleKey: String {
    case playerTitle
    case del
    case add
    case load
    case getInfo
    case auth
    case reg
    case hi
    case inputIdentifier
    case checkIdentifier
    case badIdentifier
    case notFound
    case musicTitle
    case settingsTitle
    case emptyTracklist
    case tracklistTitle
    case titleSMain
    case titleSAccount
    case titleSDesign
    case setting0
    case setting1
    case setting2
    case setting3
    case install
    case emailSet
    case youEmail
}

class LocalesManager {
    
    static public let s = LocalesManager()
    private init() {}
    
    public let locale = PListsManager.s.loadPList(AppStaticData.locales.first ?? "")! as! [String: String]

    public func get(_ key: LocaleKey) -> String {
        return locale[key.rawValue] != nil ? locale[key.rawValue]! : "---"
    }
    
    public func get(_ key: LocaleKey) -> String? {
        return locale[key.rawValue]
    }
    
}
