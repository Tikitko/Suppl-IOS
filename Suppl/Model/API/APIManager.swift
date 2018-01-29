import Foundation

class APIManager {
    
    private let api: APIRequest
    
    init(api: APIRequest = APIRequest()) {
        self.api = api
    }
    
    public func userRegister(dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        UserService.register(api: api, dataReport: dataReport)
    }
    
    public func userGet(ikey: Int, akey: Int, dataReport: @escaping (NSError?, UserData?) -> ()) {
        UserService.get(api: api, ikey: ikey, akey: akey, dataReport: dataReport)
    }
    
    public func userUpdateEmail(ikey: Int, akey: Int, email: String, dataReport: @escaping (NSError?, Bool?) -> ()) {
        UserService.updateEmail(api: api, ikey: ikey, akey: akey, email: email, dataReport: dataReport)
    }
    
    public func userSendResetKey(email: String, dataReport: @escaping (NSError?, Bool?) -> ()) {
        UserService.sendResetKey(api: api, email: email, dataReport: dataReport)
    }
    
    public func userReset(resetKey: String, dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        UserService.reset(api: api, resetKey: resetKey, dataReport: dataReport)
    }
    
    public func audioSearch(ikey: Int, akey: Int, query: String, offset: Int = 0, dataReport: @escaping (NSError?, AudioSearchData?) -> ()) {
        AudioService.search(api: api, ikey: ikey, akey: akey, query: query, dataReport: dataReport)
    }
    
    public func audioGet(ikey: Int, akey: Int, ids: String, dataReport: @escaping (NSError?, AudioListData?) -> ()) {
        AudioService.get(api: api, ikey: ikey, akey: akey, ids: ids, dataReport: dataReport)
    }
    
    public func tracklistGet(ikey: Int, akey: Int, dataReport: @escaping (NSError?, TracklistData?) -> ()) {
        TracklistService.get(api: api, ikey: ikey, akey: akey, dataReport: dataReport)
    }
    
    public func tracklistAdd(ikey: Int, akey: Int, trackID: String, to: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        TracklistService.add(api: api, ikey: ikey, akey: akey, trackID: trackID, to: to, dataReport: dataReport)
    }
    
    public func tracklistRemove(ikey: Int, akey: Int, from: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        TracklistService.remove(api: api, ikey: ikey, akey: akey, from: from, dataReport: dataReport)
    }
    
    public func tracklistMove(ikey: Int, akey: Int, from: Int = 0, to: Int = 0, dataReport: @escaping (NSError?, Bool?) -> ()) {
        TracklistService.move(api: api, ikey: ikey, akey: akey, from: from, to: to, dataReport: dataReport)
    }
}
