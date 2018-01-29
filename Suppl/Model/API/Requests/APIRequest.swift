import Foundation

final class APIRequest: CommonRequest {
    
    let API_URL = "https://wioz.su/suppl/api/0.1/"
    
    public func request(query: Dictionary<String, String>, taskCallback: @escaping (NSError?, NSDictionary?) -> ()) {
        super.request(url: API_URL, query: query) { error, data in
            if let error = error {
                taskCallback(NSError(domain: error.localizedDescription, code: -1), nil)
                return
            }
            guard let json = data, let dataParsed = try? JSONSerialization.jsonObject(with: json, options: []) as? NSDictionary, let data = dataParsed else {
                taskCallback(NSError(domain: "JSON Parse error", code: -2), nil)
                return
            }
            if let errorID = data["error_id"] as? Int, let errorDesc = data["error_description"] as? String {
                taskCallback(NSError(domain: errorDesc, code: errorID), nil)
            } else if let data = data["data"] as? NSDictionary {
                taskCallback(nil, data)
            }
        }
    }
    
    override public func request(url: String, query: Dictionary<String, String>, taskCallback: @escaping (Error?, Data?) -> ()) {
        return;
    }
    
    public func method<T>(query: Dictionary<String, String>, dataReport: @escaping (NSError?, T?) -> (), method: @escaping (_ data: NSDictionary) -> T?) {
        self.request(query: query) { error, data in
            var returnError: NSError? = nil
            var returnData: T? = nil
            if let error = error {
                returnError = error
            } else if let data = data {
                guard let tempData = method(data) else { return }
                returnData = tempData
            }
            DispatchQueue.main.async {
                dataReport(returnError, returnData)
            }
        }
    }
    
}

