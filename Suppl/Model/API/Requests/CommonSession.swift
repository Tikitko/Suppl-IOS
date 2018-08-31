import Foundation

class CommonSession {
    
    private let defaultSession: URLSession
    
    init(sessionConfig config: URLSessionConfiguration? = nil) {
        let sessionConfig: URLSessionConfiguration
        if let config = config {
            sessionConfig = config
        } else {
            sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 5
        }
        defaultSession = URLSession(configuration: sessionConfig)
    }
    
    public func request(url: String, query: Dictionary<String, String> = [:], inMainQueue: Bool = true, taskCallback: @escaping (Error?, URLResponse?, Data?) -> ()) {
        var urlComponents = URLComponents(string: url)
        urlComponents?.queryItems = query.map { URLQueryItem(name: "\($0)", value: "\($1)") }
        defaultSession.dataTask(with: urlComponents!.url!) { data, response, error in
            !inMainQueue ? taskCallback(error, response, data) : DispatchQueue.main.async() { taskCallback(error, response, data) }
        }.resume()
    }
    
}
