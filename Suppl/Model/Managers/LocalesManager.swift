import Foundation

final class LocalesManager {
    
    public enum Expression: String {
        case playerTitle, del, add, load, getInfo, auth, reg, hi, inputIdentifier, checkIdentifier, badIdentifier,
        notFound, musicTitle, settingsTitle, emptyTracklist, tracklistTitle, titleSMain, titleSAccount, titleSDesign,
        setting0, setting1, setting2, setting3, install, emailSet, youEmail, addOk, addError, removeOk, removeError,
        moveOk, moveError, noOffline, noInOffline, setting4, on, off, setting5, clear, serverError, setting6,
        coreDataLoadError, coreDataLoading, imagesCacheRemoved, tracksCacheRemoved, searchTracklist, searchMain,
        filterTitle, filterTime, filterSearch, filterSearchT, filterSearchP, filterOK, youIdentifierLabel,
        youEmailLabel, identifierButton, emailButton, loginIn, send, resetTitle, keySent, setting7
    }
    
    static public let s = LocalesManager()
    private init() {}
    
    public let locale: [String: String] = {
        let localesList = AppStaticData.locales
        let localeSystem = NSLocale.preferredLanguages.first
        let localePList = localesList.first(where: { $0 == localeSystem }) ?? localesList.first(where: { localeSystem?.hasPrefix($0) ?? false }) ?? localesList.first ?? String()
        return PListsManager.s.loadPList(localePList) as? [String: String] ?? [:]
    }()

    public func get(_ expression: Expression) -> String {
        let keyString = expression.rawValue
        return locale[keyString] ?? keyString
    }
    
    public func get(apiErrorCode code: Int) -> String {
        let keyString = "APIError_\(code)"
        return locale[keyString] ?? keyString
    }
    
}
