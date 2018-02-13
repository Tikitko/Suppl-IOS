import Foundation

final class APIRequest: CommonRequest {
    
    // API DOC: https://wioz.su/suppl/API_v0.1.pdf
    
    public static let API_URL = "https://wioz.su/suppl/api/0.1/"
    
    public func method<T>(_ method: String, query: Dictionary<String, String>, dataReport: @escaping (NSError?, T?) -> (), externalMethod: @escaping (_ data: ResponseData<T>) -> T?) {
        var mainQuery: Dictionary<String, String> = ["method": method]
        mainQuery.merge(other: query)
        super.request(url: APIRequest.API_URL, query: mainQuery, inMain: false) { error, response, data in
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
            DispatchQueue.main.async {
                dataReport(returnError, returnData)
            }
        }
    }
    
}

extension Dictionary {
    mutating func merge(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}


