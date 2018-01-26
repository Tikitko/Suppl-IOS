import Foundation

final class APIRequest: CommonRequest {
    
    let API_URL = "https://wioz.su/suppl/api/0.1/"
    
    public func request(query: Dictionary<String, String>, taskCallback: @escaping (NSError?, ResponseData?) -> ()) {
        super.request(url: API_URL, query: query) { error, data in
            if let error = error {
                taskCallback(NSError(domain: error.localizedDescription, code: -1), nil)
            }
            if let data = data {
                let reportData = try? JSONDecoder().decode(ResponseData.self, from: data)
                print(reportData)
                taskCallback(nil, reportData)
            }
            /*
            if let error_id = data["error_id"] as? Int, let error_desc = data["error_description"] as? String {
                taskCallback(NSError(domain: error_desc, code: error_id), nil)
            } else if let data = data["data"] as? NSDictionary {
                taskCallback(nil, data)
            } else if let data = data["data"] as? [NSDictionary] {
                taskCallback(nil, ["list":data])
            }
            */
        }
    }
    
    override public func request(url: String, query: Dictionary<String, String>, taskCallback: @escaping (Error?, Data?) -> ()) {
        return;
    }
    /*
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
     */
}

