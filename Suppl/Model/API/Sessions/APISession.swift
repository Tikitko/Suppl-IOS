import Foundation

class APISession {
    
    public static let API_URL = "https://wioz.su/suppl/api/0.2.1/"
    
    enum ResponseError: Error {
        case web(Error)
        case api(id: Int, description: String)
        case parsing
    }
    
    struct ResponseData<T: Codable>: Codable {
        var status: Int
        var errorID: Int?
        var errorDesc: String?
        var data: T?
        enum CodingKeys: String, CodingKey {
            case status
            case errorID = "error_id"
            case errorDesc = "error_description"
            case data
        }
    }
    
    private let session = CommonSession()
    
    public func method<T>(_ method: String, query: Dictionary<String, String>, queue: DispatchQueue? = .main, wrapper: @escaping (_ data: ResponseData<T>) -> T?, completionHandler: @escaping (ResponseError?, T?) -> ()) {
        func completed(error: ResponseError? = nil, data: T? = nil) {
            func reporter() {
                completionHandler(error, data)
            }
            if let queue = queue {
                queue.async(execute: reporter)
            } else {
                reporter()
            }
        }
        guard !OfflineModeManager.shared.checkAndOnIfNeeded() else {
            completed()
            return
        }
        let finalQuery = query.merging(["method": method], uniquingKeysWith: { $1 })
        session.request(url: type(of: self).API_URL, query: finalQuery, queue: nil) { error, response, data in
            if let error = error {
                completed(error: .web(error))
            } else if let data = data, let dataObj = try? JSONDecoder().decode(ResponseData<T>.self, from: data) {
                if let errorID = dataObj.errorID, let errorDesc = dataObj.errorDesc {
                    completed(error: .api(id: errorID, description: errorDesc))
                } else {
                    completed(data: wrapper(dataObj))
                }
            } else {
                completed(error: .parsing)
            }
        }
    }
    
}


