import Foundation

final class APIManager {

    static public let s = APIManager()
    private init() {}
    
    private let userService = UserService()
    private let audioService = AudioService()
    private let tracklistService = TracklistService()
    
    public func userRegister(dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        userService.register(dataReport: dataReport)
    }
    
    public func userGet(keys: KeysPair, dataReport: @escaping (NSError?, UserData?) -> ()) {
        userService.get(keys: keys, dataReport: dataReport)
    }
    
    public func userUpdateEmail(keys: KeysPair,email: String, dataReport: @escaping (NSError?, Bool?) -> ()) {
        userService.updateEmail(keys: keys, email: email, dataReport: dataReport)
    }
    
    public func userSendResetKey(email: String, dataReport: @escaping (NSError?, Bool?) -> ()) {
        userService.sendResetKey(email: email, dataReport: dataReport)
    }
    
    public func userReset(resetKey: String, dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        userService.reset(resetKey: resetKey, dataReport: dataReport)
    }
    
    public func audioSearch(keys: KeysPair, query: String, offset: Int = 0, dataReport: @escaping (NSError?, AudioSearchData?) -> ()) {
        audioService.search(keys: keys, query: query, offset: offset, dataReport: dataReport)
    }
    
    public func audioGet(keys: KeysPair, ids: String, dataReport: @escaping (NSError?, AudioListData?) -> ()) {
        audioService.get(keys: keys, ids: ids, dataReport: dataReport)
    }
    
    public func tracklistGet(keys: KeysPair, dataReport: @escaping (NSError?, TracklistData?) -> ()) {
        tracklistService.get(keys: keys, dataReport: dataReport)
    }
    
    public func tracklistAdd(keys: KeysPair, trackID: String, to: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        tracklistService.add(keys: keys, trackID: trackID, to: to, dataReport: dataReport)
    }
    
    public func tracklistRemove(keys: KeysPair, from: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        tracklistService.remove(keys: keys, from: from, dataReport: dataReport)
    }
    
    public func tracklistMove(keys: KeysPair, from: Int = 0, to: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        tracklistService.move(keys: keys, from: from, to: to, dataReport: dataReport)
    }
}
