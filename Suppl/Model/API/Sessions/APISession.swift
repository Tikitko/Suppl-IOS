import Foundation

class APISession {
    
    public static let API_URL = "https://wioz.su/suppl/api/0.2.1/"
    
    private let session = CommonSession()
    
    public func method<T>(_ method: String, query: Dictionary<String, String>, queue: DispatchQueue? = .main, dataReport: @escaping (NSError?, T?) -> (), externalMethod: @escaping (_ data: ResponseData<T>) -> T?) {
        guard !OfflineModeManager.shared.checkAndOnIfNeeded() else { return }
        let finalQuery = query.merging(["method": method], uniquingKeysWith: { $1 })
        session.request(url: type(of: self).API_URL, query: finalQuery, queue: nil) { error, response, data in
            let report: (error: NSError?, data: T?)
            if let error = error {
                report = (.init(domain: error.localizedDescription, code: -2), nil)
            } else if let data = data, let dataObj = try? JSONDecoder().decode(ResponseData<T>.self, from: data) {
                if let errorID = dataObj.errorID, let errorDesc = dataObj.errorDesc {
                    report = (.init(domain: errorDesc, code: errorID), nil)
                } else {
                    report = (nil, externalMethod(dataObj))
                }
            } else {
                report = (.init(domain: "data_processing_error", code: -1), nil)
            }
            let dataReport: () -> Void = { dataReport(report.error, report.data) }
            if let queue = queue {
                queue.async(execute: dataReport)
            } else {
                dataReport()
            }
        }
    }
    
}


