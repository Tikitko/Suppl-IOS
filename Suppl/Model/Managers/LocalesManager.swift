import Foundation

final class LocalesManager {
    
    public enum Expression: String {
        case playerTitle, del, add, load, getInfo, auth, reg, hi, inputIdentifier, checkIdentifier, badIdentifier,
        notFound, musicTitle, settingsTitle, emptyTracklist, tracklistTitle, titleSMain, titleSAccount, titleSDesign,
        setting0, setting1, setting2, setting3, install, emailSet, youEmail, addOk, addError, removeOk, removeError
    }
    
    static public let s = LocalesManager()
    private init() {}
    
    public let locale = PListsManager.s.loadPList(AppStaticData.locales.first ?? "")! as! [String: String]

    public func get(_ expression: Expression) -> String {
        return locale[expression.rawValue] ?? "---"
    }
    
    public func get(_ expression: Expression) -> String? {
        return locale[expression.rawValue]
    }
    
}
