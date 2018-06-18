import Foundation

class APIRequest {
    
    public static let API_URL = "https://wioz.su/suppl/api/0.2/" // DOC: https://wioz.su/suppl/API_v0.2.pdf
    
    private let session = CommonRequest()
    
    public func method<T>(_ method: String, query: Dictionary<String, String>, dataReport: @escaping (NSError?, T?) -> (), externalMethod: @escaping (_ data: ResponseData<T>) -> T?) {
        if OfflineModeManager.s.offlineMode { return }
        if !OfflineModeManager.s.isConnectedToNetwork() {
            OfflineModeManager.s.on()
            return
        }
        let finalQuery = query.merging(["method": method], uniquingKeysWith: { (_, last) in last })
        session.request(url: APIRequest.API_URL, query: finalQuery, inMainQueue: false) { error, response, data in
            var returnError: NSError? = nil
            var returnData: T? = nil
            if let error = error {
                returnError = NSError(domain: error.localizedDescription, code: -2)
            } else if let data = data, let dataObj = try? JSONDecoder().decode(ResponseData<T>.self, from: data) {
                if let errorID = dataObj.errorID, let errorDesc = dataObj.errorDesc {
                    returnError = NSError(domain: errorDesc, code: errorID)
                } else {
                    returnData = externalMethod(dataObj)
                }
            } else {
                returnError = NSError(domain: "get_data_error", code: -3)
            }
            DispatchQueue.main.async { dataReport(returnError, returnData) }
        }
    }
    
}


