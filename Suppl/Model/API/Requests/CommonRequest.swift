import Foundation

class CommonRequest {
    
    private let defaultSession: URLSession = URLSession(configuration: .default)
    
    public func request(url: String, query: Dictionary<String, String> = [:], inMain: Bool = false, taskCallback: @escaping (Error?, URLResponse?, Data?) -> ()) {
        guard var urlComponents = URLComponents(string: url) else { return }
        let queryItems = query.map {
            return URLQueryItem(name: "\($0)", value: "\($1)")
        }
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return }
        defaultSession.dataTask(with: url) { data, response, error in
            if !inMain {
                taskCallback(error, response, data)
                return
            }
            DispatchQueue.main.async() {
                taskCallback(error, response, data)
            }
        }.resume()
    }
    
}
