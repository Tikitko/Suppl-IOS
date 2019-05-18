import Foundation

final class LocalesManager {
    
    static public let shared = LocalesManager()
    private init() {}
    
    private let locale: [String: String] = {
        let localesList = AppDelegate.locales
        let localeSystem = NSLocale.preferredLanguages.first
        let localePList = localesList.first(where: { $0 == localeSystem }) ??
                          localesList.first(where: { localeSystem?.hasPrefix($0) ?? false }) ??
                          localesList.first ??
                          String()
        return localePList.plist as? [String: String] ?? [:]
    }()

    public func localized(_ key: String) -> String {
        return locale[key] ?? key
    }
    
    public func localized(apiSessionError: APISession.ResponseError) -> String {
        let keyString: String
        switch apiSessionError {
        case .api(let id, _):
            keyString = "APIError_\(id)"
        case .parsing:
            keyString = "APIRequestError_1"
        case .web(_):
            keyString = "APIRequestError_2"
        }
        return localized(keyString)
    }
    
}
