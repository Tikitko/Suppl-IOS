import Foundation

class SupplAPI {
    
    private let api: APIRequest
    
    init(api: APIRequest = APIRequest()) {
        self.api = api
    }
    /*
    public func userRegister(dataReport: @escaping (NSError?, UserSecretData?) -> ()) {
        User.register(api: api, dataReport: dataReport)
    }
    */
    public func userGet(ikey: Int, akey: Int, dataReport: @escaping (NSError?, UserData?) -> ()) {
        User.get(api: api, ikey: ikey, akey: akey, dataReport: dataReport)
    }
    /*
    public func audioSearch(ikey: Int, akey: Int, query: String, offset: Int = 0, dataReport: @escaping (NSError?, AudioSearchData?) -> ()) {
        Audio.search(api: api, ikey: ikey, akey: akey, query: query, dataReport: dataReport)
    }
    
    public func audioGet(ikey: Int, akey: Int, ids: String, dataReport: @escaping (NSError?, AudioListData?) -> ()) {
        Audio.get(api: api, ikey: ikey, akey: akey, ids: ids, dataReport: dataReport)
    }*/
}
