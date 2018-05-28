import Foundation

class CommonRequest {
    
    private let defaultSession: URLSession
    
    init() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 5
        defaultSession = URLSession(configuration: sessionConfig)
    }
    
    public func request(url: String, query: Dictionary<String, String> = [:], inMainQueue: Bool = true, taskCallback: @escaping (Error?, URLResponse?, Data?) -> ()) {
        guard var urlComponents = URLComponents(string: url) else { return }
        urlComponents.queryItems = query.map { return URLQueryItem(name: "\($0)", value: "\($1)") }
        defaultSession.dataTask(with: urlComponents.url!) { data, response, error in
            !inMainQueue ? taskCallback(error, response, data) : DispatchQueue.main.async() { taskCallback(error, response, data) }
        }.resume()
    }
    
}
