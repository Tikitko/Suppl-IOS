import Foundation

class APIManager {

    private(set) static var API = APIRequest()
    
    public static func userRegister(dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        UserService.register(api: API, dataReport: dataReport)
    }
    
    public static func userGet(ikey: Int, akey: Int, dataReport: @escaping (NSError?, UserData?) -> ()) {
        UserService.get(api: API, ikey: ikey, akey: akey, dataReport: dataReport)
    }
    
    public static func userUpdateEmail(ikey: Int, akey: Int, email: String, dataReport: @escaping (NSError?, Bool?) -> ()) {
        UserService.updateEmail(api: API, ikey: ikey, akey: akey, email: email, dataReport: dataReport)
    }
    
    public static func userSendResetKey(email: String, dataReport: @escaping (NSError?, Bool?) -> ()) {
        UserService.sendResetKey(api: API, email: email, dataReport: dataReport)
    }
    
    public static func userReset(resetKey: String, dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        UserService.reset(api: API, resetKey: resetKey, dataReport: dataReport)
    }
    
    public static func audioSearch(ikey: Int, akey: Int, query: String, offset: Int = 0, dataReport: @escaping (NSError?, AudioSearchData?) -> ()) {
        AudioService.search(api: API, ikey: ikey, akey: akey, query: query, dataReport: dataReport)
    }
    
    public static func audioGet(ikey: Int, akey: Int, ids: String, dataReport: @escaping (NSError?, AudioListData?) -> ()) {
        AudioService.get(api: API, ikey: ikey, akey: akey, ids: ids, dataReport: dataReport)
    }
    
    public static func tracklistGet(ikey: Int, akey: Int, dataReport: @escaping (NSError?, TracklistData?) -> ()) {
        TracklistService.get(api: API, ikey: ikey, akey: akey, dataReport: dataReport)
    }
    
    public static func tracklistAdd(ikey: Int, akey: Int, trackID: String, to: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        TracklistService.add(api: API, ikey: ikey, akey: akey, trackID: trackID, to: to, dataReport: dataReport)
    }
    
    public static func tracklistRemove(ikey: Int, akey: Int, from: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        TracklistService.remove(api: API, ikey: ikey, akey: akey, from: from, dataReport: dataReport)
    }
    
    public static func tracklistMove(ikey: Int, akey: Int, from: Int = 0, to: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        TracklistService.move(api: API, ikey: ikey, akey: akey, from: from, to: to, dataReport: dataReport)
        
    }
    
    public static func errorHandler(_ inError: NSError) -> String {
        var error = inError.domain
        switch error {
        case "system_spam_control":
            error = "Спам контроль"
        case "account_user_not_found":
            error = "Пользователь не найден"
        case "account_wrong_access_key":
            error = "Неверный идентификатор"
        case "account_ip_clamed":
            error = "Повторная регистрация невозможна"
        case "account_database_error":
            error = "Ошибка сервера"
        default:
            break
        }
        return error
    }
}
