import Foundation

final class APIManager {

    static public let s = APIManager()
    private init() {}
    
    private let API = APIRequest()
    
    private let userService = UserService()
    private let audioService = AudioService()
    private let tracklistService = TracklistService()
    
    public func userRegister(dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        userService.register(api: API, dataReport: dataReport)
    }
    
    public func userGet(keys: KeysPair, dataReport: @escaping (NSError?, UserData?) -> ()) {
        userService.get(api: API, keys: keys, dataReport: dataReport)
    }
    
    public func userUpdateEmail(keys: KeysPair,email: String, dataReport: @escaping (NSError?, Bool?) -> ()) {
        userService.updateEmail(api: API, keys: keys, email: email, dataReport: dataReport)
    }
    
    public func userSendResetKey(email: String, dataReport: @escaping (NSError?, Bool?) -> ()) {
        userService.sendResetKey(api: API, email: email, dataReport: dataReport)
    }
    
    public func userReset(resetKey: String, dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        userService.reset(api: API, resetKey: resetKey, dataReport: dataReport)
    }
    
    public func audioSearch(keys: KeysPair, query: String, offset: Int = 0, dataReport: @escaping (NSError?, AudioSearchData?) -> ()) {
        audioService.search(api: API, keys: keys, query: query, offset: offset, dataReport: dataReport)
    }
    
    public func audioGet(keys: KeysPair, ids: String, dataReport: @escaping (NSError?, AudioListData?) -> ()) {
        audioService.get(api: API, keys: keys, ids: ids, dataReport: dataReport)
    }
    
    public func tracklistGet(keys: KeysPair, dataReport: @escaping (NSError?, TracklistData?) -> ()) {
        tracklistService.get(api: API, keys: keys, dataReport: dataReport)
    }
    
    public func tracklistAdd(keys: KeysPair, trackID: String, to: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        tracklistService.add(api: API, keys: keys, trackID: trackID, to: to, dataReport: dataReport)
    }
    
    public func tracklistRemove(keys: KeysPair, from: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        tracklistService.remove(api: API, keys: keys, from: from, dataReport: dataReport)
    }
    
    public func tracklistMove(keys: KeysPair, from: Int = 0, to: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        tracklistService.move(api: API, keys: keys, from: from, to: to, dataReport: dataReport)
    }
}

extension NSError {
    public func getAPIErrorString() -> String {
        return LocalesManager.s.locale["APIError_\(code)"] ?? domain
    }
}
