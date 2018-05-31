import Foundation

final class LocalesManager {
    
    public enum Expression: String {
        case playerTitle, del, add, load, getInfo, auth, reg, hi, inputIdentifier, checkIdentifier, badIdentifier,
        notFound, musicTitle, settingsTitle, emptyTracklist, tracklistTitle, titleSMain, titleSAccount, titleSDesign,
        setting0, setting1, setting2, setting3, install, emailSet, youEmail, addOk, addError, removeOk, removeError,
        moveOk, moveError, noOffline, noInOffline, setting4, on, off, setting5, clear
    }
    
    static public let s = LocalesManager()
    private init() {}
    
    public let locale = PListsManager.s.loadPList(AppStaticData.locales.first ?? "")! as! [String: String]
    private let empty = "---"

    public func get(_ expression: Expression) -> String {
        return locale[expression.rawValue] ?? empty
    }
    
    public func get(apiErrorCode code: Int) -> String {
        return locale["APIError_\(code)"] ?? empty
    }
    
}
