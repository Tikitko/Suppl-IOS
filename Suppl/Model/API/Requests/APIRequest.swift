import Foundation

class APIRequest {
    
    // API DOC: https://wioz.su/suppl/API_v0.1.pdf
    
    public static let API_URL = "https://wioz.su/suppl/api/0.1/"
    
    private let session = CommonRequest()
    
    public func method<T>(_ method: String, query: Dictionary<String, String>, dataReport: @escaping (NSError?, T?) -> (), externalMethod: @escaping (_ data: ResponseData<T>) -> T?) {
        let finalQuery = query.merging(["method": method], uniquingKeysWith: { (_, last) in last })
        session.request(url: APIRequest.API_URL, query: finalQuery, inMainQueue: false) { error, response, data in
            var dataShell: ResponseData<T>? = nil
            var returnError: NSError? = nil
            var returnData: T? = nil
            if let error = error {
                returnError = NSError(domain: error.localizedDescription, code: -2)
            } else if let data = data, let dataObj = try? JSONDecoder().decode(ResponseData<T>.self, from: data) {
                dataShell = dataObj
                if let errorID = dataObj.errorID, let errorDesc = dataObj.errorDesc {
                    returnError = NSError(domain: errorDesc, code: errorID)
                } else {
                    returnData = externalMethod(dataObj)
                }
            } else {
                returnError = NSError(domain: "get_data_error", code: -3)
            }
            if AppStaticData.debugOn {
                print("APIRequest (method: \(method); Status: \(String(describing: dataShell?.status)); Error: \(String(describing: returnError)))")
            }
            DispatchQueue.main.async { dataReport(returnError, returnData) }
        }
    }
    
}


